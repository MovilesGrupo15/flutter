import 'package:flutter/material.dart';

class CaptureButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const CaptureButtonWidget({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.camera),
    );
  }
}
