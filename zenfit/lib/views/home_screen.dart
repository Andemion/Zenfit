import 'package:flutter/material.dart';
import 'package:zenfit/models/session_model.dart';
import 'package:zenfit/models/exercices_model.dart';

class HomeScreen extends StatelessWidget {



  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final List<Session> sessionList = [];

    if (sessionList.isEmpty) {
      sessionList.addAll([
        Session(
          name: 'Morning Cardio',
          sessionType: 'Renforcement cardio',
          duration: Duration(minutes: 45),
          exercises: [
            Exercise(name: 'Jumping Jacks', number: 20, duration: Duration(seconds: 30)),
          ],
          date: DateTime.now().add(Duration(hours: 2)), // Aujourd'hui
          reminder: 15,
        ),
        Session(
          name: 'Muscle Strength',
          sessionType: 'Renforcement musculaire',
          duration: Duration(minutes: 60),
          exercises: [
            Exercise(name: 'Push-ups', number: 15, duration: Duration(seconds: 40)),
          ],
          date: DateTime.now().add(Duration(days: 1, hours: 3)), // Demain
          reminder: 10,
        ),
        Session(
          name: 'Evening Cardio',
          sessionType: 'Renforcement cardio',
          duration: Duration(minutes: 50),
          exercises: [
            Exercise(name: 'Running', number: 1, duration: Duration(minutes: 30)),
          ],
          date: DateTime.now().add(Duration(days: 3, hours: 5)), // Plus tard dans la semaine
          reminder: 20,
        ),
      ]);
    }

    // Filtrer les séances pour "aujourd'hui"
    final today = DateTime.now();
    final todaySessions = sessionList.where((session) {
      return session.date.year == today.year &&
          session.date.month == today.month &&
          session.date.day == today.day;
    }).toList();

    // Séances de la semaine (sans celles d'aujourd'hui)
    final weekSessions = sessionList.where((session) {
      final difference = session.date.difference(today).inDays;
      return difference >= 1 && difference <= 7;
    }).toList();

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
                  return _buildSessionTile(session, isToday: true);
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
                  return _buildSessionTile(session);
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

  Widget _buildSessionTile(Session session, {bool isToday = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isToday ? Colors.blue : const Color(0xFFEBE9E9),
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
                  color: isToday ? Colors.white : Colors.blue,
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
