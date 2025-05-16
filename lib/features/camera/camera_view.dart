import 'package:ecosnap/features/camera/photopreview_view.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';

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

  /// Captura la foto y navega al preview
  Future<void> _takePicture() async {
    if (!_controller.value.isInitialized || _controller.value.isTakingPicture) return;
    try {
      final XFile file = await _controller.takePicture();
      // Pasamos file.path al preview
      final bool? confirmed = await Navigator.push<bool>(
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
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/homeView'),
        ),
        title: const Text('Escanear Residuo'),
        backgroundColor: const Color(0xFF2ECC71),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: CameraPreview(_controller),
              )
                  : const Center(child: CircularProgressIndicator()),
            ),
            Container(
              height: screenHeight * 0.3,
              width: double.infinity,
              color: Colors.green,
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: _takePicture,
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(120, 120),
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Colors.white,
                  elevation: 2,
                ),
                child: const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
Para cambiar el tamaño del botón:
 • Ajusta `fixedSize: Size(width, height)`.
*/
