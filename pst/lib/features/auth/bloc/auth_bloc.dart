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
      add(_AuthUserChanged(user));
    });

    on<_AuthUserChanged>(_onAuthUserChanged);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  void _onAuthUserChanged(_AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(AuthAuthenticated(event.user!));
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
      // Si la déconnexion échoue, on doit remettre l'état précédent.
      // Pour la simplicité, on suppose que l'utilisateur est toujours authentifié.
      // Dans un cas réel, on pourrait vouloir inspecter l'état actuel.
      final currentUser = _authRepository.user.first; // Ceci est juste un exemple
      if (await currentUser != null) {
        emit(AuthAuthenticated(await currentUser!));
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
