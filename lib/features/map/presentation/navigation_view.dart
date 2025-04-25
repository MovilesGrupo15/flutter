import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:ecosnap/features/map/data/recycling_point_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/services/location_service.dart';

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
    final pos = await LocationService().getCurrentLocation();
    final start = LatLng(pos.latitude, pos.longitude);
    final end = LatLng(point!.latitude, point!.longitude);

    setState(() {
      userPosition = start;
    });

    final url =
        'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final coords = data['routes'][0]['geometry']['coordinates'] as List;
      final distance = data['routes'][0]['distance'];
      final duration = data['routes'][0]['duration'];

      setState(() {
        totalDistanceMeters = (distance as num).toDouble();
        totalDurationSeconds = (duration as num).toDouble();

        routePoints = coords
            .map((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
            .toList();
      });
    } else {
      debugPrint("Error al cargar la ruta: ${response.statusCode}");
    }
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

  @override
  Widget build(BuildContext context) {
    if (point == null || userPosition == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Navegación"),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: userPosition!,
              initialZoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: userPosition!,
                    width: 50,
                    height: 50,
                    child: const Icon(Icons.person_pin_circle,
                        color: Colors.red, size: 40),
                  ),
                  Marker(
                    point: LatLng(point!.latitude, point!.longitude),
                    width: 50,
                    height: 50,
                    child: const Icon(Icons.recycling,
                        color: Colors.blue, size: 35),
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
          ),
          if (totalDistanceMeters != null && totalDurationSeconds != null)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 2)),
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
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: openInGoogleMaps,
        icon: const Icon(Icons.navigation),
        label: const Text("Abrir en Google Maps"),
      ),
    );
  }
}
