import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../state/map_mediator.dart';
import 'point_detail_view.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late final MapController _mapController;
  String? selectedPointId;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    Future.microtask(() async {
      final mediator = Provider.of<MapMediator>(context, listen: false);
      await mediator.fetchLocation();
      await mediator.loadRecyclingPoints();

      final pos = mediator.currentPosition;
      if (pos != null) {
        _mapController.move(LatLng(pos.latitude, pos.longitude), 13.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapMediator = Provider.of<MapMediator>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Puntos Cercanos", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // MAPA
          Expanded(
            flex: 2,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(4.7110, -74.0721),
                initialZoom: 13.0,
                onTap: (_, __) {
                  // ✅ Oculta el nombre si se toca fuera de un marker
                  setState(() {
                    selectedPointId = null;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                if (mapMediator.currentPosition != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(
                          mapMediator.currentPosition!.latitude,
                          mapMediator.currentPosition!.longitude,
                        ),
                        width: 50.0,
                        height: 50.0,
                        child: const Icon(Icons.location_pin,
                            color: Colors.red, size: 40),
                      ),
                    ],
                  ),

                // MARCADORES DE PUNTOS
                MarkerLayer(
                  markers: mapMediator.recyclingPoints.map((point) {
                    final isSelected = selectedPointId == point.id;

                    return Marker(
                      point: LatLng(point.latitude, point.longitude),
                      width: 100.0,
                      height: 100.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          isSelected
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PointDetailView(point: point),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black26, blurRadius: 4)
                                      ],
                                    ),
                                    child: Text(
                                      point.name,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                )
                              : const SizedBox(height: 24), // Espacio fijo
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPointId = point.id;
                              });
                            },
                            child: const Icon(Icons.recycling,
                                color: Colors.blue, size: 30),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // LISTA DE PUNTOS
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListView.builder(
                itemCount: mapMediator.recyclingPoints.length,
                itemBuilder: (context, index) {
                  final point = mapMediator.recyclingPoints[index];
                  final distance = point.distanceMeters;
                  final distanceText = distance != null
                      ? (distance >= 1000
                          ? "${(distance / 1000).toStringAsFixed(1)} km"
                          : "${distance.toStringAsFixed(0)} m")
                      : '';

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        point.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(point.description),
                          if (distanceText.isNotEmpty)
                            Text("Distancia: $distanceText"),
                        ],
                      ),
                      leading: const Icon(Icons.recycling, color: Colors.green),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PointDetailView(point: point),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () async {
          await mapMediator.fetchLocation();
          await mapMediator.loadRecyclingPoints();

          final pos = mapMediator.currentPosition;
          if (pos != null) {
            _mapController.move(LatLng(pos.latitude, pos.longitude), 13.0);
          }
        },
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
