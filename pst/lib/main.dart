import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:pst/features/auth/bloc/auth_bloc.dart';
import 'package:pst/features/auth/data/auth_repository.dart';
import 'package:pst/features/business/bloc/business_bloc.dart';
import 'package:pst/features/business/data/business_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pst/features/reviews/bloc/review_bloc.dart';
import 'package:pst/features/reviews/data/review_repository.dart';
import 'core/routes/app_router.dart';

// Service Locator
final sl = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger les variables d'environnement
  await dotenv.load(fileName: ".env");

  // Déterminer les options Firebase en fonction de la plateforme
  FirebaseOptions firebaseOptions;
  if (kIsWeb) {
    firebaseOptions = FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_WEB_API_KEY']!,
      appId: dotenv.env['FIREBASE_WEB_APP_ID']!,
      messagingSenderId: dotenv.env['FIREBASE_WEB_MESSAGING_SENDER_ID']!,
      projectId: dotenv.env['FIREBASE_WEB_PROJECT_ID']!,
      authDomain: dotenv.env['FIREBASE_WEB_AUTH_DOMAIN']!,
      storageBucket: dotenv.env['FIREBASE_WEB_STORAGE_BUCKET']!,
    );
  } else {
    // Supposons Android pour l'instant, car c'était la seule config fournie
    firebaseOptions = FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_ANDROID_API_KEY']!,
      appId: dotenv.env['FIREBASE_ANDROID_APP_ID']!,
      messagingSenderId: dotenv.env['FIREBASE_ANDROID_MESSAGING_SENDER_ID']!,
      projectId: dotenv.env['FIREBASE_ANDROID_PROJECT_ID']!,
      storageBucket: dotenv.env['FIREBASE_ANDROID_STORAGE_BUCKET']!,
    );
  }

  // Initialiser Firebase
  await Firebase.initializeApp(
    options: firebaseOptions,
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
