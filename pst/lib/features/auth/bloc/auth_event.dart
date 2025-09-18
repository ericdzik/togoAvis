import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Événement déclenché lorsque l'état de l'utilisateur de Firebase change.
/// (Utilisation interne au BLoC)
class AuthUserChanged extends AuthEvent {
  final User? user;

  const AuthUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

/// Événement déclenché par l'UI pour demander une connexion.
class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Événement déclenché par l'UI pour demander une inscription.
class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const SignUpRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Événement déclenché par l'UI pour demander une déconnexion.
class SignOutRequested extends AuthEvent {}
