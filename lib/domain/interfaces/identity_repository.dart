import '../entities/identity_state.dart';

abstract class IdentityRepository {
  Future<IdentityState> ensureIdentity({bool forceRefresh = false});

  /// Refreshes the FCM token in Firestore for an already-provisioned code.
  Future<void> refreshFcmToken(String shortCode);
}

class IdentityProvisioningException implements Exception {
  const IdentityProvisioningException(this.message);

  final String message;

  @override
  String toString() => message;
}
