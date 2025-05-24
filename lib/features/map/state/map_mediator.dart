import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../data/recycling_repository.dart';
import '../data/recycling_point_model.dart';
import '../../../core/services/location_service.dart';
import '../data/recycling_cache_service.dart';
import '../../../core/services/connectivity_provider.dart';

class MapMediator extends ChangeNotifier {
  Position? _currentPosition;
  bool _isLoading = false;
  List<RecyclingPoint> _recyclingPoints = [];
  List<RecyclingPoint> _filteredPoints = [];

  String? _selectedMaterial;
  List<String> _availableMaterials = [];

  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  List<RecyclingPoint> get recyclingPoints => _filteredPoints;
  String? get selectedMaterial => _selectedMaterial;
  List<String> get availableMaterials => _availableMaterials;

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

    try {
      final isConnected = await ConnectivityProvider.checkConnection();
      if (isConnected) {
        _recyclingPoints = await RecyclingRepository().getRecyclingPoints();
        debugPrint('Datos cargados desde API');
      } else {
        _recyclingPoints = RecyclingCacheService.getRecyclingPoints();
        debugPrint('Datos cargados desde caché local');
      }
    } catch (e) {
      debugPrint("Error cargando puntos: $e");
      _recyclingPoints = RecyclingCacheService.getRecyclingPoints();
    }

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

    // Extraemos materiales únicos
    _availableMaterials = _recyclingPoints
        .map((p) => p.residuoNombre)
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    applyFilter();
    _isLoading = false;
    notifyListeners();
  }

  void setMaterialFilter(String? material) {
    _selectedMaterial = material;
    applyFilter();
    notifyListeners();
  }

  void applyFilter() {
    if (_selectedMaterial == null || _selectedMaterial!.isEmpty) {
      _filteredPoints = List.from(_recyclingPoints);
    } else {
      _filteredPoints = _recyclingPoints
          .where((point) => point.residuoNombre == _selectedMaterial)
          .toList();
    }
  }
}
