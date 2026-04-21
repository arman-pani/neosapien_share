import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../firebase_options.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseService instance = FirebaseService._();

  FirebaseApp? _app;

  FirebaseApp get app {
    final app = _app;
    if (app == null) {
      throw StateError('FirebaseService.initialize must complete before use.');
    }

    return app;
  }

  FirebaseFirestore get firestore => FirebaseFirestore.instanceFor(app: app);
  FirebaseStorage get storage =>
      FirebaseStorage.instanceFor(app: app, bucket: _storageBucket);
  FirebaseMessaging get messaging => FirebaseMessaging.instance;

  String get projectId => DefaultFirebaseOptions.currentPlatform.projectId;
  String? get _storageBucket => DefaultFirebaseOptions.currentPlatform.storageBucket;

  Future<FirebaseApp> initialize() async {
    if (_app != null) {
      return _app!;
    }

    final app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _app = app;
    return app;
  }
}

// Firestore schema:
// users/{shortCode}: { shortCode, createdAt, fcmToken? }
// transfers/{transferId}: { senderId, recipientCode, status, files[], createdAt, expiresAt }
// transfers/{transferId}/files/{fileId}: { name, size, mimeType, storageUrl, sha256, progress }
