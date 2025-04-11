import 'package:ecosnap/features/login/views/register_view.dart';
import 'package:ecosnap/views/home_view.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/auth_service.dart';
import 'features/login/viewmodels/login_viewmodel.dart';
import 'features/map/presentation/map_view.dart';
import 'features/map/state/map_mediator.dart';
import 'features/login/views/login_screen.dart'; // Asegúrate de que la importación sea correcta

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegura que Flutter está inicializado
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyAzHUFRc37HRYLNi-Wq-N6LNpKxsTlAwYk',
        appId: '1:145925009398:android:a2339e560fc34f08e821d7',
        messagingSenderId: 'sendid',
        projectId: 'ecosnap-9503c',
        storageBucket: 'ecosnap-9503c.firebasestorage.app',
      )
  ); FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  runApp(
    MultiProvider(
      providers: [
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
      initialRoute: '/',
      routes: {
        '/': (context) => LoginView(),
        '/mapView': (context) => MapView(),
        '/homeView': (context) => HomeView(),
        '/registerView':(context) => RegisterView()
      },
    );
  }
}
