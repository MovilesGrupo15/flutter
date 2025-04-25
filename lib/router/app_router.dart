import 'package:flutter/material.dart';
import '../features/login/views/login_screen.dart';
import '../features/login/views/register_view.dart';
import '../features/map/presentation/map_view.dart';
import '../features/map/presentation/point_detail_view.dart';
import '../features/map/presentation/navigation_view.dart';
import '../features/map/presentation/feedback_view.dart';
import '../views/home_view.dart';
import '../features/map/data/recycling_point_model.dart';

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
      case '/homeView':
        return MaterialPageRoute(
          builder: (_) => HomeView(),
          settings: settings,
        );
      case '/mapView':
        return MaterialPageRoute(
          builder: (_) => MapView(),
          settings: settings,
        );
      case '/pointDetail':
        final point = args as RecyclingPoint;
        return MaterialPageRoute(
          builder: (_) => PointDetailView(point: point),
          settings: settings,
        );
      case '/navigation':
        return MaterialPageRoute(
          builder: (_) => const NavigationView(),
          settings: settings,
        );
      case '/feedback':
        return MaterialPageRoute(
          builder: (_) => const FeedbackView(),
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
