import 'package:flutter/material.dart';
import 'package:zenfit/widgets/bottom_bar.dart';

class PlanningScreen extends StatelessWidget {
  const PlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planning'),
      ),
      body: const Center(
        child: Text(
          'Bienvenue sur l\'écran du planning',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
