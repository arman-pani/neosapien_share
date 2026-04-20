import '../../data/remote_data_sources/firebase_service.dart';

abstract class RecipientLookupRepository {
  Future<bool> userExists(String shortCode);
}

class FirestoreRecipientLookupRepository implements RecipientLookupRepository {
  FirestoreRecipientLookupRepository({required FirebaseService firebaseService})
    : _firebaseService = firebaseService;

  final FirebaseService _firebaseService;

  @override
  Future<bool> userExists(String shortCode) async {
    final snapshot = await _firebaseService.firestore
        .collection('users')
        .doc(shortCode)
        .get();

    return snapshot.exists;
  }
}
