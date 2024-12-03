import 'package:flutter/material.dart';

class HistoricScreen extends StatelessWidget {
  const HistoricScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'Bienvenue sur l\'écran d\'historique',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
