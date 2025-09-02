import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  AuthenticationService();

  Future<String> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = userCredential.user?.uid;
    if (uid == null) {
      throw Exception('Failed to obtain uid after sign up');
    }
    return uid;
  }

  Future<String> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = userCredential.user?.uid;
    if (uid == null) {
      throw Exception('Failed to obtain uid after sign in');
    }
    return uid;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  String? getCurrentUserId() {
    return firebaseAuth.currentUser?.uid;
  }
}
