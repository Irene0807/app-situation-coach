import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String usersCollectionName;

  DatabaseService({
    this.usersCollectionName = 'users',
  });

  CollectionReference<Map<String, dynamic>> get _users => _firestore
      .collection(usersCollectionName)
      .withConverter<Map<String, dynamic>>(
        fromFirestore: (snap, _) => snap.data() ?? <String, dynamic>{},
        toFirestore: (data, _) => data,
      );

  Future<void> createUserDoc({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(usersCollectionName).doc(uid).set(data);
  }

  Future<Map<String, dynamic>?> getUserDoc({
    required String uid,
  }) async {
    final doc = await _firestore.collection(usersCollectionName).doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  Future<void> updateUserDoc({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(usersCollectionName).doc(uid).update(data);
  }
}
