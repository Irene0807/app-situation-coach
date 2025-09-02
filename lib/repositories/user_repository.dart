import '../services/authentication.dart';
import '../services/database.dart';
import '../models/user.dart';

class UserRepository {
  final AuthenticationService authService;
  final DatabaseService dbService;

  UserRepository({
    required this.authService,
    required this.dbService,
  });

  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String name,
    required int age,
  }) async {
    final uid = await authService.signUpWithEmailPassword(
        email: email, password: password);
    final data = {
      'name': name,
      'age': age,
      'email': email,
    };
    await dbService.createUserDoc(uid: uid, data: data);
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    await authService.signInWithEmailPassword(email: email, password: password);
    // optional: you can fetch user doc here if needed
  }

  Future<void> logout() async {
    await authService.signOut();
  }

  Future<User?> getCurrentAppUser() async {
    final uid = authService.getCurrentUserId();
    if (uid == null) return null;
    final doc = await dbService.getUserDoc(uid: uid);
    if (doc == null) return null;
    return User.fromMap(uid, doc);
  }
}
