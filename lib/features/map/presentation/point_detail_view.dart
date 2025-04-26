import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:ecosnap/features/map/data/recycling_point_model.dart';
import '../data/recycling_repository.dart';
import '../../../core/services/connectivity_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PointDetailView extends StatefulWidget {
  final RecyclingPoint point;

  const PointDetailView({super.key, required this.point});

  @override
  State<PointDetailView> createState() => _PointDetailViewState();
}

class _PointDetailViewState extends State<PointDetailView> {
  late Future<RecyclingPoint>? _futureDetail;
  bool _wasOffline = false;
  bool _showReconnectMessage = false;

  @override
  void initState() {
    super.initState();
    final isOnline = context.read<ConnectivityProvider>().isOnline;
    _futureDetail = isOnline
        ? RecyclingRepository().getRecyclingPointDetail(widget.point.id)
        : null;
    _wasOffline = !isOnline;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isOnline = context.watch<ConnectivityProvider>().isOnline;
    if (_wasOffline && isOnline && (_futureDetail == null)) {
      setState(() {
        _futureDetail = RecyclingRepository().getRecyclingPointDetail(widget.point.id);
        _wasOffline = false;
        _showReconnectMessage = true;
      });
    } else if (!isOnline) {
      _wasOffline = true;
    }
  }

  void openInGoogleMaps() async {
    final destination = '${widget.point.latitude},${widget.point.longitude}';
    final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$destination&travelmode=driving');

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
    final isOnline = context.watch<ConnectivityProvider>().isOnline;

    if (_showReconnectMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: const Text('Conexión restablecida. Recargando información...'),
            duration: const Duration(seconds: 3),
          ),
        );
      });
      _showReconnectMessage = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.point.name),
        backgroundColor: Colors.green,
      ),
      body: !isOnline && _futureDetail == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    const Text(
                      'Sin conexión',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'No se pudo cargar la información del punto porque no hay conexión a Internet.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: openInGoogleMaps,
                      icon: const Icon(Icons.map, color: Colors.white),
                      label: const Text("Abrir en Google Maps", style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/feedback', arguments: widget.point);
                      },
                      icon: const Icon(Icons.feedback, color: Colors.green),
                      label: const Text("Enviar feedback"),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      label: const Text("Volver", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            )
          : FutureBuilder<RecyclingPoint>(
              future: _futureDetail,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Ocurrió un error inesperado."));
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text("No hay datos disponibles."));
                }

                final fullPoint = snapshot.data!;
                final distanceText = widget.point.distanceMeters != null
                    ? (widget.point.distanceMeters! >= 1000
                        ? "${(widget.point.distanceMeters! / 1000).toStringAsFixed(1)} km"
                        : "${widget.point.distanceMeters!.toStringAsFixed(0)} m")
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
                        Text("Dirección: ${fullPoint.address}", style: const TextStyle(color: Colors.grey)),
                      if (fullPoint.telefono?.isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text("Teléfono: ${fullPoint.telefono!}", style: const TextStyle(color: Colors.grey)),
                        ),
                      if (fullPoint.horario.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text("Horario: ${fullPoint.horario}", style: const TextStyle(color: Colors.grey)),
                        ),
                      if (fullPoint.residuoNombre.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text("Residuo: ${fullPoint.residuoNombre}", style: const TextStyle(color: Colors.grey)),
                        ),
                      if (fullPoint.localidadNombre != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text("Localidad: ${fullPoint.localidadNombre!}", style: const TextStyle(color: Colors.grey)),
                        ),
                      if (fullPoint.fecha != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text("Fecha de registro: ${fullPoint.fecha!}", style: const TextStyle(color: Colors.grey)),
                        ),
                      if (distanceText.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text("Distancia: $distanceText", style: const TextStyle(color: Colors.grey)),
                        ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: 200,
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(fullPoint.latitude, fullPoint.longitude),
                              initialZoom: 15.0,
                              interactionOptions: InteractionOptions(flags: InteractiveFlag.none),
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
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isOnline ? Colors.green : Colors.grey,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        onPressed: isOnline
                            ? () {
                                Navigator.pushNamed(context, '/navigation', arguments: fullPoint);
                              }
                            : null,
                        icon: const Icon(Icons.directions, color: Colors.white),
                        label: const Text("Cómo llegar", style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/feedback', arguments: fullPoint);
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
