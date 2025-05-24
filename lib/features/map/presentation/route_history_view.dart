import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../data/route_history_service.dart';
import '../data/route_history_model.dart';
import '../../../core/services/connectivity_provider.dart';

class RouteHistoryView extends StatefulWidget {
  const RouteHistoryView({super.key});

  @override
  State<RouteHistoryView> createState() => _RouteHistoryViewState();
}

class _RouteHistoryViewState extends State<RouteHistoryView> {
  late Future<List<RouteHistory>> _futureHistory;

  @override
  void initState() {
    super.initState();
    _futureHistory = RouteHistoryService.getHistory();
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<ConnectivityProvider>().isOnline;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Rutas"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          if (!isOnline)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.9),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
                ],
              ),
              child: const Text(
                'Sin conexión. Historial cargado localmente.',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: FutureBuilder<List<RouteHistory>>(
              future: _futureHistory,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "Error al cargar el historial.",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                final history = snapshot.data ?? [];

                if (history.isEmpty) {
                  return const Center(
                    child: Text(
                      "Aún no hay rutas registradas.",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                history.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // más recientes primero

                return ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final entry = history[index];
                    final formattedDate = DateFormat('dd/MM/yyyy – HH:mm').format(entry.timestamp);

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 3,
                      child: ListTile(
                        leading: const Icon(Icons.history, color: Colors.green),
                        title: Text(entry.pointName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Visitado el $formattedDate"),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
