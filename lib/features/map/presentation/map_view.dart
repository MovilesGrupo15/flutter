import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../state/map_mediator.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  void initState() {
    super.initState();
    // Llamamos a los métodos del mediator al construir la vista
    Future.microtask(() {
      final mediator = Provider.of<MapMediator>(context, listen: false);
      mediator.fetchLocation();
      mediator.loadRecyclingPoints();
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
              options: MapOptions(
                initialCenter: mapMediator.currentPosition != null
                    ? LatLng(
                        mapMediator.currentPosition!.latitude,
                        mapMediator.currentPosition!.longitude)
                    : const LatLng(4.7110, -74.0721),
                initialZoom: 13.0,
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
                          mapMediator.currentPosition!.longitude),
                        width: 50.0,
                        height: 50.0,
                        child: const Icon(Icons.location_pin,
                            color: Colors.red, size: 40),
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: mapMediator.recyclingPoints.map((point) {
                    return Marker(
                      point: LatLng(point.latitude, point.longitude),
                      width: 50.0,
                      height: 50.0,
                      child: Tooltip(
                        message: point.name,
                        child: const Icon(Icons.recycling, color: Colors.blue, size: 30),
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
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        point.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(point.description),
                      leading: const Icon(Icons.recycling, color: Colors.green),
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
        onPressed: () {
          mapMediator.fetchLocation();
          mapMediator.loadRecyclingPoints();
        },
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
