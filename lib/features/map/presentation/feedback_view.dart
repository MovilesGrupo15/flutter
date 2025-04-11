import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:ecosnap/features/map/data/recycling_point_model.dart';

class FeedbackView extends StatefulWidget {
  final RecyclingPoint point;

  const FeedbackView({super.key, required this.point});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  final _formKey = GlobalKey<FormState>();

  String? accuracyFeedback;
  String? materialsFeedback;
  String? closureFeedback;

  bool submitted = false;

Future<void> sendFeedback() async {
  if (!_formKey.currentState!.validate()) return;

  _formKey.currentState!.save();

  await FirebaseAnalytics.instance.logEvent(
    name: "recycling_point_feedback",
    parameters: {
      "point_id": widget.point.id,
      "accuracy_feedback": accuracyFeedback ?? "",
      "materials_feedback": materialsFeedback ?? "",
      "closure_feedback": closureFeedback ?? "",
    },
  );

  setState(() {
    submitted = true;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enviar Feedback"),
        backgroundColor: Colors.green,
      ),
      body: submitted
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text("¡Gracias por tu feedback!",
                    style: TextStyle(fontSize: 20)),
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
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: "Ej: Muy precisa"),
                      onSaved: (value) => accuracyFeedback = value,
                      validator: (value) =>
                          value == null || value.isEmpty ? "Requerido" : null,
                    ),
                    const SizedBox(height: 20),

                    Text("¿Qué materiales aceptan realmente?",
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText: "Ej: Solo plástico y papel"),
                      onSaved: (value) => materialsFeedback = value,
                      validator: (value) =>
                          value == null || value.isEmpty ? "Requerido" : null,
                    ),
                    const SizedBox(height: 20),

                    Text("¿Estaba abierto y operativo?",
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText: "Ej: Estaba cerrado por mantenimiento"),
                      onSaved: (value) => closureFeedback = value,
                      validator: (value) =>
                          value == null || value.isEmpty ? "Requerido" : null,
                    ),
                    const SizedBox(height: 30),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14)),
                      onPressed: sendFeedback,
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: const Text("Enviar",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
