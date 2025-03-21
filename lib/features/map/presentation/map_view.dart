import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../state/map_mediator.dart';

class MapView extends StatelessWidget {
  const MapView({super.key}); // Fix the missing 'key' issue

  @override
  Widget build(BuildContext context) {
    final mapMediator = Provider.of<MapMediator>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Mapa de Reciclaje")),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: mapMediator.currentPosition != null
                  ? LatLng(
                      mapMediator.currentPosition!.latitude,
                      mapMediator.currentPosition!.longitude)
                  : const LatLng(4.7110, -74.0721), // Bogotá default
              initialZoom: 13.0,  // Fix for missing 'zoom' parameter
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
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                mapMediator.fetchLocation();
                mapMediator.loadRecyclingPoints();
              },
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }
}
