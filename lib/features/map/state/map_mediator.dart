import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../data/recycling_repository.dart';
import '../data/recycling_point_model.dart';
import '../../../core/services/location_service.dart';

class MapMediator extends ChangeNotifier {
  Position? _currentPosition;
  bool _isLoading = false;
  List<RecyclingPoint> _recyclingPoints = [];

  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  List<RecyclingPoint> get recyclingPoints => _recyclingPoints;

  Future<void> fetchLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentPosition = await LocationService().getCurrentLocation();
    } catch (e) {
      debugPrint("Error fetching location: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadRecyclingPoints() async {
    _isLoading = true;
    notifyListeners();

    _recyclingPoints = await RecyclingRepository().getRecyclingPoints();

    if (_currentPosition != null) {
      for (var point in _recyclingPoints) {
        final distance = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          point.latitude,
          point.longitude,
        );
        point.distanceMeters = distance;
      }

      _recyclingPoints.sort((a, b) =>
          (a.distanceMeters ?? 0).compareTo(b.distanceMeters ?? 0));
    }

    _isLoading = false;
    notifyListeners();
  }
}
