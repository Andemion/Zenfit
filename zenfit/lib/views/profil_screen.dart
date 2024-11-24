import 'package:flutter/material.dart';
import 'package:zenfit/widgets/bottom_bar.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: const Center(
        child: Text(
          'Bienvenue sur votre profil',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}