import 'package:flutter/material.dart';
import 'package:zenfit/widgets/bottom_bar.dart';

class HistoricScreen extends StatelessWidget {
  const HistoricScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
      ),
      body: const Center(
        child: Text(
          'Bienvenue sur l\'écran d\'historique',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
