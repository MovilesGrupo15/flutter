import 'package:flutter/material.dart';
import '../features/login/views/login_screen.dart';
import '../features/login/views/register_view.dart';
import '../features/map/presentation/map_view.dart';
import '../views/home_view.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => LoginView(),
          settings: settings,
        );
      case '/registerView':
        return MaterialPageRoute(
          builder: (_) => RegisterView(),
          settings: settings,
        );
      case '/loginView':
        return MaterialPageRoute(
          builder: (_) => LoginView(),
          settings: settings,
        );
      case '/mapView':
        return MaterialPageRoute(
          builder: (_) => MapView(),
          settings: settings,
        );
      case '/homeView':
        return MaterialPageRoute(
          builder: (_) => HomeView(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Página no encontrada')),
          ),
        );
    }
  }
}
