import 'package:flutter/material.dart';
import 'package:zenfit/widgets/bottom_bar.dart';
import 'package:zenfit/views/profil_screen.dart';
import 'package:zenfit/views/home_screen.dart';
import 'package:zenfit/views/planning_screen.dart';
import 'package:zenfit/views/historic_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const PlanningScreen(),
    const HistoricScreen(),
    const ProfilScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
            backgroundColor: Color(0xFF1A43EE),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Planning',
            backgroundColor: Color(0xFF1A43EE),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
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
      ),
    );
  }
}
