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
        apiKey: 'AIzaSyC2Gx3nvVezcqMwI0QMuGL7bjwYgSH1vHI',
        appId: '1:554273153067:android:c5a5d85dc2969e7ef1ca6e',
        messagingSenderId: 'sendid',
        projectId: 'myapp',
        storageBucket: 'myapp-b9yt18.appspot.com',
      )
  );
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
        '/mapView': (context) => MapView()
      },
    );
  }
}
