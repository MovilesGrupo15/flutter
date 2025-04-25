import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ecosnap/features/map/data/recycling_point_model.dart';
import '../data/recycling_repository.dart';

class PointDetailView extends StatelessWidget {
  final RecyclingPoint point;

  const PointDetailView({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(point.name),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<RecyclingPoint>(
        future: RecyclingRepository().getRecyclingPointDetail(point.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No hay datos"));
          }

          final fullPoint = snapshot.data!;
          final distanceText = point.distanceMeters != null
              ? (point.distanceMeters! >= 1000
                  ? "${(point.distanceMeters! / 1000).toStringAsFixed(1)} km"
                  : "${point.distanceMeters!.toStringAsFixed(0)} m")
              : "Distancia no disponible";

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  fullPoint.name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                if (fullPoint.address.isNotEmpty)
                  Text(
                    "Dirección: ${fullPoint.address}",
                    style: const TextStyle(color: Colors.grey),
                  ),

                if (fullPoint.telefono != null && fullPoint.telefono!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Teléfono: ${fullPoint.telefono!}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),

                if (fullPoint.horario.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Horario: ${fullPoint.horario}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),

                if (fullPoint.residuoNombre.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Residuo: ${fullPoint.residuoNombre}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),

                if (fullPoint.localidadNombre != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Localidad: ${fullPoint.localidadNombre!}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),

                if (fullPoint.fecha != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Fecha de registro: ${fullPoint.fecha!}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),

                if (distanceText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Distancia: $distanceText",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),

                const SizedBox(height: 16),

                // 🌍 MINI MAPA
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 200,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(fullPoint.latitude, fullPoint.longitude),
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
                              point: LatLng(fullPoint.latitude, fullPoint.longitude),
                              child: const Icon(Icons.location_on, color: Colors.blue, size: 35),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 🚀 BOTÓN DE NAVEGACIÓN
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/navigation', // 🔥 ahora sí correcto
                      arguments: fullPoint,
                    );
                  },
                  icon: const Icon(Icons.directions, color: Colors.white),
                  label: const Text("Cómo llegar", style: TextStyle(color: Colors.white)),
                ),

                const SizedBox(height: 12),

                // 📝 BOTÓN DE FEEDBACK
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/feedback', // 🔥 ahora sí correcto
                      arguments: fullPoint,
                    );
                  },
                  icon: const Icon(Icons.feedback, color: Colors.green),
                  label: const Text("Enviar feedback"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
