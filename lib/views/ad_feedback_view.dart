import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
import '../../core/services/connectivity_provider.dart';

class AdFeedbackView extends StatefulWidget {
  const AdFeedbackView({super.key});

  @override
  State<AdFeedbackView> createState() => _AdFeedbackViewState();
}

class _AdFeedbackViewState extends State<AdFeedbackView> {
  bool? isRelevant;
  bool? isIntrusive;
  bool submitted = false;
  bool _lastStatusOnline = true;

  Future<void> sendAdFeedback() async {
    if (isRelevant == null || isIntrusive == null) return;

    await FirebaseAnalytics.instance.logEvent(
      name: "ad_feedback",
      parameters: {
        "is_relevant": isRelevant! ? 1 : 0,
        "is_intrusive": isIntrusive! ? 1 : 0,
      },
    );

    setState(() {
      submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<ConnectivityProvider>().isOnline;

    // Detectar cambio en conectividad
    if (_lastStatusOnline != isOnline) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: isOnline ? Colors.green : Colors.red,
            content: Text(isOnline
                ? 'Conexión restablecida'
                : 'Sin conexión a Internet'),
            duration: const Duration(seconds: 2),
          ),
        );
      });
      _lastStatusOnline = isOnline;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback de Anuncios"),
        backgroundColor: Colors.green,
      ),
      body: submitted
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  "¡Gracias por tu feedback!",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    "¿Los anuncios son relevantes para ti?",
                    style: TextStyle(fontSize: 18),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text("Sí"),
                          value: true,
                          groupValue: isRelevant,
                          onChanged: (val) => setState(() => isRelevant = val),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text("No"),
                          value: false,
                          groupValue: isRelevant,
                          onChanged: (val) => setState(() => isRelevant = val),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "¿Los anuncios interrumpen tu experiencia?",
                    style: TextStyle(fontSize: 18),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text("Sí"),
                          value: true,
                          groupValue: isIntrusive,
                          onChanged: (val) => setState(() => isIntrusive = val),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text("No"),
                          value: false,
                          groupValue: isIntrusive,
                          onChanged: (val) => setState(() => isIntrusive = val),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: (isRelevant != null && isIntrusive != null)
                        ? sendAdFeedback
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text("Enviar"),
                  ),
                ],
              ),
            ),
    );
  }
}
