import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:ecosnap/features/map/data/recycling_point_model.dart';
import 'package:provider/provider.dart';
import '../../../core/services/connectivity_provider.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  final _formKey = GlobalKey<FormState>();

  int accuracyStars = 0;
  String? materialsCorrect;
  String? wasOpen;

  bool submitted = false;

  Future<void> sendFeedback(RecyclingPoint point) async {
    if (materialsCorrect == null || wasOpen == null || accuracyStars == 0) return;

    await FirebaseAnalytics.instance.logEvent(
      name: "recycling_point_feedback",
      parameters: {
        "point_id": point.id,
        "accuracy_stars": accuracyStars,
        "materials_correct": materialsCorrect ?? "",
        "was_open": wasOpen ?? "",
      },
    );

    setState(() {
      submitted = true;
    });
  }

  Widget buildStarRating() {
    return Row(
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return IconButton(
          onPressed: () {
            setState(() {
              accuracyStars = starIndex;
            });
          },
          icon: Icon(
            Icons.star,
            color: accuracyStars >= starIndex ? Colors.orange : Colors.grey,
          ),
        );
      }),
    );
  }

  Widget buildYesNoRadioGroup(String label, String? currentValue, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        RadioListTile<String>(
          title: const Text("Sí"),
          value: "sí",
          groupValue: currentValue,
          onChanged: onChanged,
        ),
        RadioListTile<String>(
          title: const Text("No"),
          value: "no",
          groupValue: currentValue,
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final point = ModalRoute.of(context)!.settings.arguments as RecyclingPoint;
    final isOnline = context.watch<ConnectivityProvider>().isOnline;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Enviar Feedback"),
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
                      child: Text("¡Gracias por tu feedback!", style: TextStyle(fontSize: 20)),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          Text("¿Qué tan precisa es la ubicación del punto?",
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 6),
                          buildStarRating(),
                          const SizedBox(height: 20),
                          buildYesNoRadioGroup(
                            "¿Los materiales aceptados eran correctos?",
                            materialsCorrect,
                            (val) => setState(() => materialsCorrect = val),
                          ),
                          const SizedBox(height: 20),
                          buildYesNoRadioGroup(
                            "¿El punto estaba operativo?",
                            wasOpen,
                            (val) => setState(() => wasOpen = val),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => sendFeedback(point),
                            icon: const Icon(Icons.send, color: Colors.white),
                            label: const Text("Enviar", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
