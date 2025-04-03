import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:ecosnap/features/map/data/recycling_point_model.dart';
import '../../../core/services/location_service.dart';

class NavigationView extends StatefulWidget {
  final RecyclingPoint point;

  const NavigationView({super.key, required this.point});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  List<LatLng> routePoints = [];
  LatLng? userPosition;

  double? totalDistanceMeters;
  double? totalDurationSeconds;

  @override
  void initState() {
    super.initState();
    loadRoute();
  }

  Future<void> loadRoute() async {
    final pos = await LocationService().getCurrentLocation();
    final start = LatLng(pos.latitude, pos.longitude);
    final end = LatLng(widget.point.latitude, widget.point.longitude);

    setState(() {
      userPosition = start;
    });

    final url =
        'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final route = data['routes'][0];

      final coords = route['geometry']['coordinates'] as List;
      final distance = route['distance']; // metros
      final duration = route['duration']; // segundos

      setState(() {
        routePoints = coords
            .map((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
            .toList();
        totalDistanceMeters = distance;
        totalDurationSeconds = duration;
      });
    } else {
      debugPrint("Error al cargar la ruta: ${response.statusCode}");
    }
  }

  String get distanceText {
    if (totalDistanceMeters == null) return "Distancia: -";
    return totalDistanceMeters! >= 1000
        ? "Distancia: ${(totalDistanceMeters! / 1000).toStringAsFixed(1)} km"
        : "Distancia: ${totalDistanceMeters!.toStringAsFixed(0)} m";
  }

  String get durationText {
    if (totalDurationSeconds == null) return "Duración: -";
    final minutes = (totalDurationSeconds! / 60).round();
    return "Duración estimada: ${minutes} min";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Navegación"),
        backgroundColor: Colors.green,
      ),
      body: userPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 🗺️ MAPA CON RUTA
                Expanded(
                  child: FlutterMap(
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
                            point: LatLng(widget.point.latitude, widget.point.longitude),
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
                ),

                // 📏 INFORMACIÓN DE RUTA
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  color: Colors.grey[100],
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        distanceText,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        durationText,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
