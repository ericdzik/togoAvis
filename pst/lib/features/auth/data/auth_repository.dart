import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserModel> signIn(String email, String password) async {
    final result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = result.user;
    if (user != null) {
      return UserModel(uid: user.uid, email: user.email ?? '');
    } else {
      throw Exception('Authentication failed');
    }
  }
}
