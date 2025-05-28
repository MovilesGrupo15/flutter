import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
import '../../../core/services/connectivity_provider.dart';

class DirectionFeedbackView extends StatefulWidget {
  const DirectionFeedbackView({super.key});

  @override
  State<DirectionFeedbackView> createState() => _DirectionFeedbackViewState();
}

class _DirectionFeedbackViewState extends State<DirectionFeedbackView> {
  int clarityStars = 0;
  String comment = "";
  bool submitted = false;

  Future<void> sendDirectionFeedback() async {
    if (clarityStars == 0) return;

    await FirebaseAnalytics.instance.logEvent(
      name: "direction_feedback",
      parameters: {
        "clarity_stars": clarityStars,
        if (comment.isNotEmpty) "comment": comment,
      },
    );

    setState(() {
      submitted = true;
    });
  }

  Widget buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return IconButton(
          onPressed: () {
            setState(() {
              clarityStars = starIndex;
            });
          },
          icon: Icon(
            Icons.star,
            size: 36,
            color: clarityStars >= starIndex ? Colors.orange : Colors.grey,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<ConnectivityProvider>().isOnline;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Evaluar Dirección"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: isOnline ? Colors.green : Colors.red,
            child: Text(
              isOnline ? "Conectado a Internet" : "Sin conexión a Internet",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: submitted
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        "¡Gracias por tu respuesta!",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      children: [
                        const Text(
                          "¿Qué tan clara fue la indicación para llegar al punto correcto?",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        buildStarRating(),
                        const SizedBox(height: 24),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Comentario (opcional)",
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          onChanged: (value) {
                            setState(() {
                              comment = value;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          onPressed: sendDirectionFeedback,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.send, color: Colors.white),
                          label: const Text(
                            "Enviar",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
