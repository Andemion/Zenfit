import 'package:flutter/material.dart';
import 'package:zenfit/views/profil_screen.dart';
import 'package:zenfit/views/home_screen.dart';
import 'package:zenfit/views/planning_screen.dart';
import 'package:zenfit/views/historic_screen.dart';

class BottomBar extends StatefulWidget {
  final Function(int) onTap;

  const BottomBar({Key? key, required this.onTap}) : super(key: key);

  @override
  _BottomBar createState() => _BottomBar();
}

class _BottomBar extends State<BottomBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTap(index);

    switch (_selectedIndex) {
      case 0:
        Navigator.pushReplacement (
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement (
          context,
          MaterialPageRoute(builder: (context) => const PlanningScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement (
          context,
          MaterialPageRoute(builder: (context) => const HistoricScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement (
          context,
          MaterialPageRoute(builder: (context) => const ProfilScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Color(0xFF1A43EE),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Planning',
          backgroundColor: Color(0xFF1A43EE),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Historic',
          backgroundColor: Color(0xFF1A43EE),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
          backgroundColor: Color(0xFF1A43EE),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      onTap: _onItemTapped,
    );
  }
}
