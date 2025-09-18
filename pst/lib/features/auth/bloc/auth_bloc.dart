import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:pst/features/auth/data/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late final StreamSubscription<User?> _userSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {

    // Souscrire au stream de l'utilisateur dès l'initialisation du BLoC
    _userSubscription = _authRepository.user.listen((user) {
      add(AuthUserChanged(user));
    });

    on<AuthUserChanged>(_onAuthUserChanged);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  void _onAuthUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    final user = event.user;
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  void _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signIn(email: event.email, password: event.password);
      // Le succès sera géré par le listener _AuthUserChanged
    } catch (e) {
      emit(AuthError(e.toString()));
      // Après une erreur, on retourne à l'état non authentifié
      emit(AuthUnauthenticated());
    }
  }

  void _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signUp(email: event.email, password: event.password);
      // Le succès sera géré par le listener _AuthUserChanged
    } catch (e) {
      emit(AuthError(e.toString()));
      // Après une erreur, on retourne à l'état non authentifié
      emit(AuthUnauthenticated());
    }
  }

  void _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      // Le succès sera géré par le listener _AuthUserChanged, qui émettra AuthUnauthenticated
    } catch (e) {
      emit(AuthError(e.toString()));
      // Si la déconnexion échoue, on doit remettre l'état précédent,
      // car l'utilisateur est probablement toujours connecté.
      final currentUser = _authRepository.currentUser;
      if (currentUser != null) {
        emit(AuthAuthenticated(currentUser));
      } else {
        emit(AuthUnauthenticated());
      }
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
