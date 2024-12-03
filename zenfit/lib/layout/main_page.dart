import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import du package Provider
import 'package:zenfit/views/home_screen.dart';
import 'package:zenfit/views/planning_screen.dart';
import 'package:zenfit/views/historic_screen.dart';
import 'package:zenfit/views/profil_screen.dart';
import 'package:zenfit/widgets/bottom_bar.dart';
import 'package:zenfit/themes/color.dart'; // Import de ThemeColorProvider
import 'package:zenfit/models/session_model.dart';
import 'package:zenfit/models/exercices_model.dart';

class MainPage extends StatefulWidget {

  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int _selectedIndex = 0; // Index initial de la page (HomeScreen)

  // Liste des pages
  List<Widget> _pages = [
    const HomeScreen(),
    PlanningScreen(),
    const HistoricScreen(),
    const ProfilScreen(),
  ];

  // Liste des titres pour chaque page
  List<String> _pageTitles = [
    'Accueil',
    'Planning',
    'Historique',
    'Profil',
  ];

  // Fonction appelée lorsque l'on change de page dans la BottomBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Récupération de la couleur du thème via le provider
    Color themeColor = Provider.of<ThemeColorProvider>(context).themeColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitles[_selectedIndex], // Mettre à jour le titre en fonction de la page active
          style: const TextStyle(color: Colors.white), // Titre en blanc
        ),
        backgroundColor: themeColor, // Application de la couleur dynamique dans l'AppBar
      ),
      body: IndexedStack(
        index: _selectedIndex, // Afficher la page sélectionnée
        children: _pages,
      ),
      bottomNavigationBar: BottomBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Changer la page en fonction de l'index
      ),
    );
  }
}
