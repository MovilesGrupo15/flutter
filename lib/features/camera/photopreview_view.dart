import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:ecosnap/core/services/connectivity_provider.dart';

class PhotoPreviewView extends StatefulWidget {
  final String imagePath;

  const PhotoPreviewView({super.key, required this.imagePath});

  @override
  State<PhotoPreviewView> createState() => _PhotoPreviewViewState();
}

class _PhotoPreviewViewState extends State<PhotoPreviewView> {
  List<dynamic> detections = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _sendImageToBackend();
  }

  Future<void> _sendImageToBackend() async {
    try {
      final bytes = await File(widget.imagePath).readAsBytes();

      final channel = WebSocketChannel.connect(
        Uri.parse('wss://ecosnap-back.onrender.com/detect'),
      );

      channel.sink.add(bytes);

      channel.stream.listen((message) {
        final data = json.decode(message);
        setState(() {
          detections = data;
          isLoading = false;
        });
        channel.sink.close();
      });
    } catch (e) {
      debugPrint('Error enviando imagen: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveConfirmedPhoto() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory imageDir = Directory(p.join(appDir.path, 'captured_images'));

      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }

      final String fileName = 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String newPath = p.join(imageDir.path, fileName);

      await File(widget.imagePath).copy(newPath);

      final box = Hive.box<String>('photoPaths');
      await box.add(newPath);

      debugPrint('Imagen guardada en: $newPath');
    } catch (e) {
      debugPrint('Error guardando imagen en Hive: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<ConnectivityProvider>().isOnline;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Previsualización'),
        backgroundColor: const Color(0xFF2ECC71),
      ),
      body: Stack(
        children: [
          Image.file(File(widget.imagePath)),
          if (!isOnline)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: MaterialBanner(
                backgroundColor: Colors.red,
                content: Text(
                  'Sin conexión. Tus datos se guardarán localmente.',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [],
              ),
            ),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            ...detections.map((detection) {
              final bbox = detection['bbox'];
              final label = detection['type'];
              final confidence = detection['confidence'];

              return Positioned(
                left: bbox[0] * MediaQuery.of(context).size.width,
                top: bbox[1] * MediaQuery.of(context).size.height,
                width: bbox[2] * MediaQuery.of(context).size.width,
                height: bbox[3] * MediaQuery.of(context).size.height,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        '$label (${(confidence * 100).toStringAsFixed(1)}%)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await _saveConfirmedPhoto();
          if (mounted) Navigator.pop(context, true);
        },
        label: const Text('Confirmar'),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
