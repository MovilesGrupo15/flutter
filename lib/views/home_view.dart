import 'package:flutter/material.dart';

import '../features/map/presentation/map_view.dart';

const Color customGreen = Color(0xFF4CAF50);

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenido ',
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
                          Image.asset('assets/images/cinecolombia.jpg'),
                          const SizedBox(height: 8),
                          const Text(
                            'Cupón CineColombia',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Nunito',
                            ),
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
                          Image.asset('assets/images/McDonalds.jpg'),
                          const SizedBox(height: 8),
                          const Text(
                            'Cupón McDonalds',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: customGreen,
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito'
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapView()),
                );
              },
              child: const Text(
                  'Ver puntos cercanos',
                    style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito'
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}