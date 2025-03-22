import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../state/map_mediator.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    final mapMediator = Provider.of<MapMediator>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Matches second image
        title: const Text("Puntos Cercanos", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white), // Ensures icons are visible
      ),
      body: Column(
        children: [
          // MAP SECTION
          Expanded(
            flex: 2, // Takes more space
            child: FlutterMap(
              options: MapOptions(
                initialCenter: mapMediator.currentPosition != null
                    ? LatLng(
                        mapMediator.currentPosition!.latitude,
                        mapMediator.currentPosition!.longitude)
                    : const LatLng(4.7110, -74.0721), // Bogotá default
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
                            color: Colors.green, size: 40),
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

          // LIST OF RECYCLING POINTS
          Expanded(
            flex: 1, // Takes less space than the map
            child: Container(
              color: Colors.white, // Matches second image background
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
        backgroundColor: Colors.purple, // Matches second image button color
        onPressed: () {
          mapMediator.fetchLocation();
          mapMediator.loadRecyclingPoints();
        },
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
