import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'core/services/connectivity_provider.dart';
import 'core/services/auth_service.dart';
import 'features/login/viewmodels/login_viewmodel.dart';
import 'features/map/state/map_mediator.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        Provider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => LoginViewModel(context.read<AuthService>())),
        ChangeNotifierProvider(create: (_) => MapMediator()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'rootApp',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.generateRoute,
      home: const AuthWrapper(), // 👈 Home dinámico
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/loginView');
      } else {
        Navigator.pushReplacementNamed(context, '/homeView');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mientras decide a dónde ir
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
