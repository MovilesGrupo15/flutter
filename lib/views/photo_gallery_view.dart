import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../core/services/connectivity_provider.dart';

class PhotoGalleryView extends StatefulWidget {
  const PhotoGalleryView({super.key});

  @override
  State<PhotoGalleryView> createState() => _PhotoGalleryViewState();
}

class _PhotoGalleryViewState extends State<PhotoGalleryView> {
  late Box<String> _photoBox;

  @override
  void initState() {
    super.initState();
    _photoBox = Hive.box<String>('photoPaths');
  }

  void _showImageDialog(String path, int index) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Image.file(File(path)),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await _photoBox.deleteAt(index);
                Navigator.pop(context);
                setState(() {});
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<ConnectivityProvider>().isOnline;
    final paths = _photoBox.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis fotos analizadas'),
        backgroundColor: const Color(0xFF2ECC71),
      ),
      body: Column(
        children: [
          if (!isOnline)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.red,
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
          Expanded(
            child: paths.isEmpty
                ? const Center(child: Text('No hay fotos guardadas.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: paths.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (_, index) {
                      final path = paths[index];
                      return GestureDetector(
                        onTap: () => _showImageDialog(path, index),
                        child: Image.file(
                          File(path),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
