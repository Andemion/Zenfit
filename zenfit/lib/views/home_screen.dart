import 'package:flutter/material.dart';
import 'package:zenfit/widgets/bottom_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
      ),
      body: const Center(
        child: Text(
          'Bienvenue sur l\'écran d\'accueil',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
