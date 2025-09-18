import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/data/auth_repository.dart';
import 'core/routes/app_router.dart';
import 'features/auth/presentation/pages/login_page.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();

  final authRepository = AuthRepository();

  runApp(TogoAvisApp(authRepository: authRepository));
}

class TogoAvisApp extends StatelessWidget {
  final AuthRepository authRepository;

  const TogoAvisApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authRepository: authRepository),
        ),
      ],
      child: MaterialApp(
        title: 'TogoAvis',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const LoginPage(), // ✅ ici tu appelles ta page
      ),
    );
  }
}
