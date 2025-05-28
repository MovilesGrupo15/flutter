import 'package:ecosnap/views/photo_gallery_view.dart';
import 'package:flutter/material.dart';
import '../features/login/views/login_screen.dart';
import '../features/login/views/register_view.dart';
import '../features/map/presentation/map_view.dart';
import '../features/map/presentation/point_detail_view.dart';
import '../features/map/presentation/navigation_view.dart';
import '../features/map/presentation/feedback_view.dart';
import '../features/map/presentation/direction_feedback_view.dart';
import '../features/map/presentation/route_history_view.dart';
import '../features/camera/camera_view.dart';
import '../views/home_view.dart';
import '../features/map/data/recycling_point_model.dart';
import '../views/ad_feedback_view.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginView(), settings: settings);
      case '/registerView':
        return MaterialPageRoute(builder: (_) => RegisterView(), settings: settings);
      case '/loginView':
        return MaterialPageRoute(builder: (_) => LoginView());
      case '/homeView':
        return MaterialPageRoute(builder: (_) => HomeView(), settings: settings);
      case '/mapView':
        return MaterialPageRoute(builder: (_) => MapView(), settings: settings);
      case '/cameraView':
        return MaterialPageRoute(builder: (_) => CameraView(), settings: settings);
      case '/pointDetail':
        final point = settings.arguments as RecyclingPoint;
        return MaterialPageRoute(builder: (_) => PointDetailView(point: point), settings: settings);
      case '/navigation':
        return MaterialPageRoute(builder: (_) => const NavigationView(), settings: settings);
      case '/feedback':
        return MaterialPageRoute(builder: (_) => const FeedbackView(), settings: settings);
      case '/directionFeedback':
        return MaterialPageRoute(builder: (_) => const DirectionFeedbackView(), settings: settings);
      case '/routeHistory':
        return MaterialPageRoute(builder: (_) => const RouteHistoryView(), settings: settings);
      case '/photoGallery':
        return MaterialPageRoute(builder: (_) => const PhotoGalleryView(), settings: settings);
      case '/adFeedback':
        return MaterialPageRoute(builder: (_) => const AdFeedbackView(), settings: settings);
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Página no encontrada')),
          ),
        );
    }
  }
}
