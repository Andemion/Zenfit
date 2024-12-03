import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:zenfit/models/session_model.dart';
import 'package:zenfit/themes/color.dart'; // Assurez-vous d'importer le ThemeColorProvider
import 'package:zenfit/models/exercises_model.dart';
import 'package:zenfit/db/sessions_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final sessionDatabase = SessionDatabase();
  List<Session> todaySessions = [];
  List<Session> weekSessions = [];
  // Récupération de la couleur du thème via le provider
  Color themeColor = Provider.of<ThemeColorProvider>(context).themeColor;

  @override
  void initState() {
    super.initState();
    getFilteredSessions();
  }

  Future<void> getFilteredSessions() async {
    // Lire toutes les sessions
    final sessionList = await sessionDatabase.readAllSessions();

    // Filtrer les sessions pour "aujourd'hui"
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    setState(() {
      todaySessions = sessionList.where((session) {
        final sessionDate = DateTime(session.date.year, session.date.month, session.date.day);
        return sessionDate == today;
      }).toList();

      // Filtrer les sessions pour la semaine
      final weekStart = today.subtract(Duration(days: today.weekday - 1));
      final weekEnd = weekStart.add(Duration(days: 6));
      weekSessions = sessionList.where((session) {
        final sessionDate = DateTime(session.date.year, session.date.month, session.date.day);
        return sessionDate.isAfter(weekStart) && sessionDate.isBefore(weekEnd.add(Duration(days: 1)));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vos séances du jour',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (todaySessions.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: todaySessions.length,
                itemBuilder: (context, index) {
                  final session = todaySessions[index];
                  return _buildSessionTile(session, isToday: true, themeColor: themeColor);
                },
              )
            else
              const Text(
                'Aucune séance pour aujourd\'hui.',
                style: TextStyle(color: Colors.black54),
              ),
            const SizedBox(height: 20),
            const Text(
              'Vos séances de la semaine',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (weekSessions.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: weekSessions.length,
                itemBuilder: (context, index) {
                  final session = weekSessions[index];
                  return _buildSessionTile(session, themeColor: themeColor);
                },
              )
            else
              const Text(
                'Aucune séance prévue cette semaine.',
                style: TextStyle(color: Colors.black54),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionTile(Session session, {bool isToday = false, required Color themeColor}) {
    return Container(
      decoration: BoxDecoration(
        color: isToday ? themeColor : const Color(0xFFEBE9E9), // Application de la couleur dynamique
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${session.date.day} ${_monthName(session.date.month)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isToday ? Colors.white : themeColor, // Changer la couleur en fonction de la condition
                ),
              ),
              const SizedBox(height: 4),
              Text(
                session.sessionType,
                style: TextStyle(
                  fontSize: 14,
                  color: isToday ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          Text(
            '${session.date.hour.toString().padLeft(2, '0')}h',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isToday ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Fév',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juil',
      'Août',
      'Sept',
      'Oct',
      'Nov',
      'Déc'
    ];
    return months[month - 1];
  }
}
