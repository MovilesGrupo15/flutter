import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:ecosnap/features/camera/photopreview_view.dart';

Future<int> _processImage(String path) async {
  final bytes = await File(path).readAsBytes();
  return bytes.length;
}

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late final CameraController _controller;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final cameras = Provider.of<List<CameraDescription>>(context, listen: false);
      _controller = CameraController(cameras.first, ResolutionPreset.high);
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      await _controller.initialize();
      if (!mounted) return;
      setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint('Error inicializando cámara: $e');
    }
  }

  Future<void> _takePicture() async {
    if (!_controller.value.isInitialized || _controller.value.isTakingPicture) return;
    try {
      final XFile file = await _controller.takePicture();
      final int size = await compute(_processImage, file.path);
      debugPrint('Tamaño de la imagen (bytes): $size');

      final bool? confirmed = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoPreviewView(imagePath: file.path),
        ),
      );

      if (confirmed == true) {
        debugPrint('Foto confirmada: ${file.path}');
      } else {
        debugPrint('Foto descartada');
      }
    } catch (e) {
      debugPrint('Error al tomar la foto: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/homeView'),
        ),
        title: const Text('Escanear residuo'),
        backgroundColor: const Color(0xFF2ECC71),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: _isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: CameraPreview(_controller),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(bottom: 40),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ElevatedButton(
                  onPressed: _takePicture,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    elevation: 10,
                    backgroundColor: Colors.white,
                    shadowColor: Colors.black45,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Color(0xFF2ECC71),
                    size: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
