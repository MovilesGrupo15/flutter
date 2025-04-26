import 'package:ecosnap/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/connectivity_provider.dart';
import 'core/services/auth_service.dart';
import 'features/login/viewmodels/login_viewmodel.dart';
import 'features/map/state/map_mediator.dart';
import 'router/app_router.dart';
import 'features/map/data/recycling_cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await RecyclingCacheService.init();

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
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
