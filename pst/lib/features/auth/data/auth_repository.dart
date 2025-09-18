import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  // Si on utilise l'injection de dépendances, il est mieux de l'injecter via le constructeur.
  // Sinon, on peut utiliser FirebaseAuth.instance directement.
  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Crée un nouvel utilisateur avec l'email et le mot de passe fournis.
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // On pourrait gérer des erreurs spécifiques ici (e.g., email-already-in-use)
      // Pour l'instant, on relance l'exception pour que le BLoC la gère.
      throw Exception('Failed to sign up: ${e.message}');
    }
  }

  /// Connecte un utilisateur avec l'email et le mot de passe fournis.
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // On pourrait gérer des erreurs spécifiques ici (e.g., user-not-found)
      throw Exception('Failed to sign in: ${e.message}');
    }
  }

  /// Déconnecte l'utilisateur actuellement authentifié.
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out');
    }
  }

  /// Un flux (Stream) qui émet l'état de l'utilisateur en temps réel.
  /// Émet un objet [User] si l'utilisateur est connecté, et `null` sinon.
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges();
  }

  /// Récupère l'utilisateur actuel de manière synchrone.
  /// Peut être `null` si aucun utilisateur n'est connecté.
  User? get currentUser {
    return _firebaseAuth.currentUser;
  }
}
