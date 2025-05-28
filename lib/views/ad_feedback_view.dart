import 'package:flutter/material.dart';

class AdFeedbackView extends StatefulWidget {
  const AdFeedbackView({super.key});

  @override
  State<AdFeedbackView> createState() => _AdFeedbackViewState();
}

class _AdFeedbackViewState extends State<AdFeedbackView> {
  bool? isRelevant;
  bool? isIntrusive;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback de Anuncios"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("¿Los anuncios son relevantes para ti?", style: TextStyle(fontSize: 18)),
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
            const Text("¿Los anuncios interrumpen tu experiencia?", style: TextStyle(fontSize: 18)),
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
                  ? () {
                      // Aquí puedes enviar el feedback a Firebase Analytics o Firestore
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("¡Gracias por tu feedback!")),
                      );
                      Navigator.pop(context);
                    }
                  : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Enviar"),
            ),
          ],
        ),
      ),
    );
  }
}
