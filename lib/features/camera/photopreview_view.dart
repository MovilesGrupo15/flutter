import 'dart:io';
import 'package:flutter/material.dart';

/// Pantalla para previsualizar la foto tomada y confirmar o descartar.
class PhotoPreviewView extends StatelessWidget {
  final String imagePath;
  const PhotoPreviewView({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previsualizar Foto'),
        backgroundColor: const Color(0xFF2ECC71),
      ),
      body: Column(
        children: [
          // Muestra la imagen ocupando todo el espacio posible
          Expanded(
            child: Image.file(
              File(imagePath),
              width: double.infinity,
            ),
          ),
          // Barra inferior con dos botones: cancelar y aceptar
          Container(
            color: Colors.grey.shade200,
            height: screenHeight * 0.3,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botón de descartar (X)
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.red,
                    fixedSize: const Size(64, 64),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                // Botón de confirmar (check)
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.green,
                    fixedSize: const Size(64, 64),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
