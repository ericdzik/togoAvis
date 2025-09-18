import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pst/features/auth/bloc/auth_bloc.dart';
import 'package:pst/features/auth/bloc/auth_state.dart';
import 'package:pst/features/auth/presentation/pages/login_page.dart';
import 'package:pst/features/auth/presentation/pages/signup_page.dart';
import 'package:pst/features/business/presentation/pages/business_detail_page.dart';
import 'package:pst/features/business/presentation/pages/home_page.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  late final GoRouter router = GoRouter(
    // Écouter les changements d'état du AuthBloc pour déclencher la redirection
    refreshListenable: GoRouterRefreshStream(authBloc.stream),

    // Définir la route initiale
    initialLocation: '/login',

    // Définir toutes les routes de l'application
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        name: 'business_detail',
        path: '/business/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BusinessDetailPage(businessId: id);
        },
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: 'signup',
        path: '/signup',
        builder: (context, state) => const SignUpPage(),
      ),
    ],

    // Logique de redirection
    redirect: (BuildContext context, GoRouterState state) {
      final authState = authBloc.state;

      final isAuthenticating = authState is AuthLoading || authState is AuthInitial;
      if (isAuthenticating) {
        // Pendant que l'on vérifie l'état, on ne redirige pas,
        // l'UI devrait montrer un splash/loader.
        return null;
      }

      final isAuthenticated = authState is AuthAuthenticated;
      final onAuthScreens = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

      if (!isAuthenticated && !onAuthScreens) {
        // Si l'utilisateur n'est pas connecté et n'est pas sur une page d'auth, le renvoyer à la connexion.
        return '/login';
      }

      if (isAuthenticated && onAuthScreens) {
        // Si l'utilisateur est connecté et essaie d'aller sur les pages de connexion/inscription,
        // le rediriger vers la page d'accueil.
        return '/';
      }

      // Pas de redirection nécessaire dans les autres cas.
      return null;
    },
  );
}

// Classe utilitaire pour convertir un Stream en Listenable pour go_router
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    stream.asBroadcastStream().listen((_) => notifyListeners());
  }
}
