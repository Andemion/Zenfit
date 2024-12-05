import 'package:flutter/material.dart';
import 'package:zenfit/widgets/session_execution_screen.dart';

class SessionStartScreen extends StatelessWidget {
  final String title;
  final int duration;
  final String type;
  final List<Map<String, dynamic>> exercises; // Liste des exercices
  final DateTime sessionDate;
  final int? sessionId;
  final int sessionReminder;

  const SessionStartScreen({
    Key? key,
    required this.title,
    required this.duration,
    required this.type,
    required this.exercises, // Ajout de l'argument exercises
    required this.sessionDate,
    required this.sessionId,
    required this.sessionReminder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: themeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$title',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Text(
              '$duration minutes',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Type: $type',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // Navigation vers SessionExecutionScreen avec la liste d'exercices
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SessionExecutionScreen(
                      sessionDate: sessionDate,
                      sessionId: sessionId,
                      sessionReminder: sessionReminder,
                      title: title,
                      duration: duration,
                      type: type,
                      exercices: exercises, // Passez la liste des exercices
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: themeColor,
                padding: const EdgeInsets.all(100),
              ),
              child: const Text(
                'Commencer !',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
