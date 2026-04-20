import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../data/remote_data_sources/firebase_service.dart';
import 'identity_state.dart';

abstract class IdentityRepository {
  Future<IdentityState> ensureIdentity({bool forceRefresh = false});

  /// Refreshes the FCM token in Firestore for an already-provisioned code.
  Future<void> refreshFcmToken(String shortCode);
}

class FirestoreIdentityRepository implements IdentityRepository {
  FirestoreIdentityRepository({
    required FirebaseService firebaseService,
    FlutterSecureStorage? secureStorage,
    Random? random,
  }) : _firebaseService = firebaseService,
       _secureStorage = secureStorage ?? const FlutterSecureStorage(),
       _random = random ?? Random.secure();

  static const _shortCodeKey = 'identity.shortCode';
  static const _uuidKey = 'identity.localUuid';
  static const _alphabet = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
  static const _codeLength = 6;
  static const _maxRetries = 5;

  final FirebaseService _firebaseService;
  final FlutterSecureStorage _secureStorage;
  final Random _random;

  @override
  Future<IdentityState> ensureIdentity({bool forceRefresh = false}) async {
    final preferences = await SharedPreferences.getInstance();
    final savedShortCode = forceRefresh
        ? null
        : preferences.getString(_shortCodeKey);
    final savedLocalUuid = forceRefresh
        ? null
        : await _secureStorage.read(key: _uuidKey);

    if (savedShortCode != null) {
      final localUuid = savedLocalUuid ?? const Uuid().v4();

      if (savedLocalUuid == null) {
        await _secureStorage.write(key: _uuidKey, value: localUuid);
      }

      // Always refresh the FCM token on every app launch so it stays current.
      await refreshFcmToken(savedShortCode);

      return IdentityState(shortCode: savedShortCode, localUuid: localUuid);
    }

    // Tradeoff: if the app is reinstalled and SharedPreferences is cleared,
    // the device will provision a brand-new short code instead of recovering
    // the previous Firestore record.
    final localUuid = savedLocalUuid ?? const Uuid().v4();
    await _secureStorage.write(key: _uuidKey, value: localUuid);

    final fcmToken = await _readFcmToken();

    for (var attempt = 0; attempt < _maxRetries; attempt++) {
      final shortCode = _generateShortCode();
      final claimed = await _claimShortCode(
        shortCode: shortCode,
        fcmToken: fcmToken,
      );

      if (!claimed) {
        continue;
      }

      await preferences.setString(_shortCodeKey, shortCode);

      return IdentityState(shortCode: shortCode, localUuid: localUuid);
    }

    throw const IdentityProvisioningException(
      'Unable to provision a short code after 5 attempts.',
    );
  }

  /// Writes the latest FCM token to Firestore users/{shortCode}.fcmToken.
  /// Silently ignores failures (e.g. offline, permission denied) so identity
  /// load is never blocked by a token refresh failure.
  @override
  Future<void> refreshFcmToken(String shortCode) async {
    try {
      final token = await _readFcmToken();
      if (token == null || token.isEmpty) return;

      await _firebaseService.firestore
          .collection('users')
          .doc(shortCode)
          .update({'fcmToken': token});
    } catch (_) {
      // Non-fatal — token refresh failures are silently swallowed.
    }
  }

  Future<bool> _claimShortCode({
    required String shortCode,
    required String? fcmToken,
  }) {
    final userRef = _firebaseService.firestore
        .collection('users')
        .doc(shortCode);

    return _firebaseService.firestore.runTransaction<bool>((transaction) async {
      final snapshot = await transaction.get(userRef);

      if (snapshot.exists) {
        return false;
      }

      transaction.set(userRef, {
        'shortCode': shortCode,
        'createdAt': FieldValue.serverTimestamp(),
        if (fcmToken != null && fcmToken.isNotEmpty) 'fcmToken': fcmToken,
      });

      return true;
    });
  }

  String _generateShortCode() {
    return List.generate(
      _codeLength,
      (_) => _alphabet[_random.nextInt(_alphabet.length)],
    ).join();
  }

  Future<String?> _readFcmToken() async {
    try {
      // Request permission first (no-op on platforms that already granted it).
      final settings = await _firebaseService.messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        return null;
      }
      return await _firebaseService.messaging.getToken();
    } catch (_) {
      return null;
    }
  }
}

class IdentityProvisioningException implements Exception {
  const IdentityProvisioningException(this.message);

  final String message;

  @override
  String toString() => message;
}
