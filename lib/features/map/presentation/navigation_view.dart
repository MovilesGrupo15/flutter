import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:ecosnap/features/map/data/recycling_point_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/connectivity_provider.dart';
import '../data/route_history_model.dart';
import '../data/route_history_service.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  List<LatLng> routePoints = [];
  LatLng? userPosition;
  double? totalDistanceMeters;
  double? totalDurationSeconds;
  RecyclingPoint? point;

  bool _initialized = false;
  bool _loadingError = false;
  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      point = ModalRoute.of(context)!.settings.arguments as RecyclingPoint;
      _initialized = true;
      loadRoute();
    }
  }

  Future<void> loadRoute() async {
    setState(() {
      _loading = true;
      _loadingError = false;
    });

    try {
      final isOnline = context.read<ConnectivityProvider>().isOnline;
      if (!isOnline) {
        setState(() {
          _loadingError = true;
          _loading = false;
        });
        return;
      }

      final pos = await LocationService().getCurrentLocation();
      final start = LatLng(pos.latitude, pos.longitude);
      final end = LatLng(point!.latitude, point!.longitude);

      setState(() {
        userPosition = start;
      });

      final url =
          'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';

      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final parsed = await compute(parseRouteResponse, response.body);

        setState(() {
          totalDistanceMeters = parsed['distance'];
          totalDurationSeconds = parsed['duration'];
          routePoints = parsed['points'];
          _loading = false;
        });

        // Guardar en historial local
        await RouteHistoryService.addEntry(
          RouteHistory(
            pointId: point!.id,
            pointName: point!.name,
            timestamp: DateTime.now(),
          ),
        );
      } else {
        debugPrint("Error al cargar la ruta: ${response.statusCode}");
        setState(() {
          _loadingError = true;
          _loading = false;
        });
      }
    } on TimeoutException catch (_) {
      debugPrint("Timeout al cargar la ruta");
      setState(() {
        _loadingError = true;
        _loading = false;
      });
    } catch (e) {
      debugPrint("Error cargando ruta: $e");
      setState(() {
        _loadingError = true;
        _loading = false;
      });
    }
  }

  static Map<String, dynamic> parseRouteResponse(String responseBody) {
    final data = jsonDecode(responseBody);
    final coords = data['routes'][0]['geometry']['coordinates'] as List;
    final distance = (data['routes'][0]['distance'] as num).toDouble();
    final duration = (data['routes'][0]['duration'] as num).toDouble();

    final points = coords.map<LatLng>((c) => LatLng(c[1].toDouble(), c[0].toDouble())).toList();

    return {
      'distance': distance,
      'duration': duration,
      'points': points,
    };
  }

  String formatDistance(double meters) {
    return meters >= 1000
        ? "${(meters / 1000).toStringAsFixed(1)} km"
        : "${meters.toStringAsFixed(0)} m";
  }

  String formatDuration(double seconds) {
    final mins = (seconds / 60).round();
    return "$mins min";
  }

  void openInGoogleMaps() async {
    if (userPosition == null || point == null) return;

    final destination = '${point!.latitude},${point!.longitude}';
    final origin = '${userPosition!.latitude},${userPosition!.longitude}';

    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving',
    );

    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error al abrir Google Maps: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo abrir Google Maps")),
      );
    }
  }

  void goToSurvey() {
    Navigator.pushNamed(context, '/directionFeedback');
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<ConnectivityProvider>().isOnline;

    if (point == null || (_loading && userPosition == null)) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Navegación"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.question_answer),
            tooltip: 'Evaluar la navegación',
            onPressed: goToSurvey,
          )
        ],
      ),
      body: Stack(
        children: [
          if (_loadingError)
            _buildErrorUI()
          else
            _buildMap(),

          if (totalDistanceMeters != null && totalDurationSeconds != null && !_loadingError)
            _buildDistanceBanner(),

          if (!isOnline)
            _buildOfflineBanner(),
        ],
      ),
      floatingActionButton: isOnline && !_loadingError
          ? FloatingActionButton.extended(
              backgroundColor: Colors.green,
              onPressed: openInGoogleMaps,
              icon: const Icon(Icons.navigation),
              label: const Text("Abrir en Google Maps"),
            )
          : null,
    );
  }

  Widget _buildErrorUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            const Text(
              'Error de conexión',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'No se pudo calcular la ruta porque falló la conexión con el servidor del mapa.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: loadRoute,
              icon: const Icon(Icons.refresh, color: Colors.green),
              label: const Text("Reintentar"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: openInGoogleMaps,
              icon: const Icon(Icons.navigation, color: Colors.white),
              label: const Text("Abrir en Google Maps", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: const Text("Volver", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: userPosition!,
        initialZoom: 14,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: userPosition!,
              width: 50,
              height: 50,
              child: const Icon(Icons.person_pin_circle, color: Colors.red, size: 40),
            ),
            Marker(
              point: LatLng(point!.latitude, point!.longitude),
              width: 50,
              height: 50,
              child: const Icon(Icons.recycling, color: Colors.blue, size: 35),
            ),
          ],
        ),
        if (routePoints.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                color: Colors.blue,
                strokeWidth: 5,
              )
            ],
          ),
      ],
    );
  }

  Widget _buildDistanceBanner() {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Distancia: ${formatDistance(totalDistanceMeters!)}",
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              "Duración: ${formatDuration(totalDurationSeconds!)}",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineBanner() {
    return Positioned(
      top: 80,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: const Text(
          'Sin conexión. Algunas funciones limitadas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
