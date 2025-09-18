import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pst/features/auth/bloc/auth_bloc.dart';
import 'package:pst/features/auth/data/auth_repository.dart';
import 'package:pst/features/business/bloc/business_bloc.dart';
import 'package:pst/features/business/data/business_repository.dart';
import 'package:pst/features/reviews/bloc/review_bloc.dart';
import 'package:pst/features/reviews/data/review_repository.dart';
import 'package:pst/firebase_options.dart';
import 'core/routes/app_router.dart';

// Service Locator
final sl = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configuration de l'injection de dépendances
  _setupDependencies();

  runApp(const TogoAvisApp());
}

void _setupDependencies() {
  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepository());
  sl.registerSingleton<BusinessRepository>(BusinessRepository());
  sl.registerSingleton<ReviewRepository>(ReviewRepository());

  // Blocs
  // On ne les met pas dans GetIt car leur cycle de vie est géré par flutter_bloc
}

class TogoAvisApp extends StatefulWidget {
  const TogoAvisApp({super.key});

  @override
  State<TogoAvisApp> createState() => _TogoAvisAppState();
}

class _TogoAvisAppState extends State<TogoAvisApp> {
  late final AuthBloc _authBloc;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(authRepository: sl<AuthRepository>());
    _appRouter = AppRouter(authBloc: _authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<BusinessBloc>(
          create: (_) => BusinessBloc(businessRepository: sl<BusinessRepository>()),
        ),
        BlocProvider<ReviewBloc>(
          create: (_) => ReviewBloc(reviewRepository: sl<ReviewRepository>()),
        ),
      ],
      child: MaterialApp.router(
        title: 'TogoAvis',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        routerConfig: _appRouter.router,
      ),
    );
  }
}
