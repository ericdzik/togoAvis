import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// État initial, l'application démarre, on ne sait pas encore si l'utilisateur est connecté.
class AuthInitial extends AuthState {}

/// État de chargement, pendant qu'une opération (connexion, inscription) est en cours.
class AuthLoading extends AuthState {}

/// État authentifié, l'utilisateur est connecté.
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// État non authentifié, on sait que l'utilisateur n'est pas connecté.
class AuthUnauthenticated extends AuthState {}

/// État d'erreur, une opération a échoué.
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
