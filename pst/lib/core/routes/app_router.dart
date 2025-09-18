import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:pst/features/auth/presentation/pages/login_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
  ],
);
