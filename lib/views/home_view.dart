import 'package:flutter/material.dart';

const Color customGreen = Color(0xFF4CAF50); // tu color verde definido

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customGreen,
        foregroundColor: Colors.white, // para que el texto sea legible
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¡Bienvenido a la HomeView!',
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Nunito-Bold',
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/crepes.jpg'),
                          const SizedBox(height: 8),
                          const Text(
                            'Cupón Crepes and Waffles',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/crepes.jpg'),
                          const SizedBox(height: 8),
                          const Text(
                            'Cupón Crepes and Waffles',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/crepes.jpg'),
                          const SizedBox(height: 8),
                          const Text(
                            'Cupón Crepes and Waffles',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                  // Puedes agregar más elementos aquí
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
