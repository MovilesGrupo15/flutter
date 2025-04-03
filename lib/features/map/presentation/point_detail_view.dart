import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ecosnap/features/map/data/recycling_point_model.dart';
import 'navigation_view.dart';

class PointDetailView extends StatelessWidget {
  final RecyclingPoint point;

  const PointDetailView({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    final distanceText = point.distanceMeters != null
        ? (point.distanceMeters! >= 1000
            ? "${(point.distanceMeters! / 1000).toStringAsFixed(1)} km"
            : "${point.distanceMeters!.toStringAsFixed(0)} m")
        : "Distancia no disponible";

    return Scaffold(
      appBar: AppBar(
        title: Text(point.name),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              point.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            if (point.address != null)
              Text(
                "Dirección: ${point.address}",
                style: const TextStyle(color: Colors.grey),
              ),
            const SizedBox(height: 8),
            Text(
              "Distancia: $distanceText",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // 🌍 MINI MAPA
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 200,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(point.latitude, point.longitude),
                    initialZoom: 15.0,
                    interactionOptions: InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 40.0,
                          height: 40.0,
                          point: LatLng(point.latitude, point.longitude),
                          child: const Icon(Icons.location_on,
                              color: Colors.blue, size: 35),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🚀 BOTÓN DE NAVEGACIÓN
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NavigationView(point: point),
                    ),
                  );
                },
                icon: const Icon(Icons.directions, color: Colors.white),
                label: const Text("Cómo llegar", style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Icon(Icons.recycling, size: 80, color: Colors.green[700]),
            ),
          ],
        ),
      ),
    );
  }
}
