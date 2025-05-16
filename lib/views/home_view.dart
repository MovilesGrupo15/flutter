import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../features/map/presentation/map_view.dart';
import '../core/services/connectivity_provider.dart'; // Ajusta la ruta según tu estructura

const Color customGreen = Color(0xFF4CAF50);

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<ConnectivityProvider>().isOnline;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: customGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Cupones'),
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Parte superior: Opciones
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Configuración'),
                    onTap: () {
                      // Aquí puedes navegar a un SettingsView o mostrar un mensaje
                      Navigator.pop(context); // cerrar el drawer
                      // Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ],
              ),
              // Parte inferior: Cerrar sesión
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, '/loginView');                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Cerrar sesión'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenido',
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Nunito-Bold',
              ),
            ),
            if (!isOnline)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Sin conexión a Internet',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito-Bold',
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('cupones').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No hay cupones disponibles"));
                  }

                  final cupones = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: cupones.length,
                    itemBuilder: (context, index) {
                      final data = cupones[index].data() as Map<String, dynamic>;
                      final nombre = data['nombre'] ?? '';
                      final descripcion = data['Descripción'] ?? '';
                      final imagenUrl = data['URL'] ?? '';
                      final puntos = data['coonpoints']?.toString() ?? '0';

                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                constraints: const BoxConstraints(maxHeight: 500),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Image.network(
                                          imagenUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.broken_image, size: 60),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        nombre,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Nunito-Bold',
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        descripcion,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Nunito',
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'CoonPoints: $puntos',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Nunito',
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: customGreen,
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cerrar'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: Image.network(
                                  imagenUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 48),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                nombre,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Nunito-Bold',
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Toca para ver más...',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Nunito',
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: customGreen,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Nunito',
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapView()),
                );
              }
              ,
              child: const Text(
                'Ver puntos cercanos',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
