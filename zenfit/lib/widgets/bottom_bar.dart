import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importer Provider pour accéder à ThemeColorProvider
import 'package:zenfit/themes/color.dart'; // Import de ThemeColorProvider

class BottomBar extends StatefulWidget {
  final Function(int) onTap;
  final int currentIndex;

  const BottomBar({Key? key, required this.onTap, required this.currentIndex}) : super(key: key);

  @override
  _BottomBar createState() => _BottomBar();
}

class _BottomBar extends State<BottomBar> {
  void _onItemTapped(int index) {
    widget.onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    // Récupération de la couleur du thème via le provider
    Color themeColor = Provider.of<ThemeColorProvider>(context).themeColor;

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: themeColor, // Application de la couleur dynamique pour l'item
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Planning',
          backgroundColor: themeColor, // Application de la couleur dynamique pour l'item
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Historic',
          backgroundColor: themeColor, // Application de la couleur dynamique pour l'item
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
          backgroundColor: themeColor, // Application de la couleur dynamique pour l'item
        ),
      ],
      currentIndex: widget.currentIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      onTap: _onItemTapped,
    );
  }
}
