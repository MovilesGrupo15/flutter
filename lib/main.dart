import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'firebase_options.dart';
import 'core/services/connectivity_provider.dart';
import 'core/services/auth_service.dart';
import 'features/login/viewmodels/login_viewmodel.dart';
import 'features/map/state/map_mediator.dart';
import 'router/app_router.dart';
import 'features/map/data/recycling_cache_service.dart';
import 'package:camera/camera.dart';

late final List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await RecyclingCacheService.init();

  Future.microtask(() async {
    try {
      final response = await http.get(Uri.parse('https://ecosnap-back.onrender.com/api/points')).timeout(const Duration(seconds: 10));
      debugPrint('Ping API: ${response.statusCode}');
    } catch (e) {
      debugPrint('Error haciendo ping al API: $e');
    }
  });

  runApp(
    MultiProvider(
      providers: [
        Provider<List<CameraDescription>>.value(value: cameras),
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
      home: const AuthWrapper(),
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
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
