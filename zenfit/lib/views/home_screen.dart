import 'package:flutter/material.dart';
import 'package:zenfit/db/sessions_database.dart';
import 'package:zenfit/models/session_model.dart';
import 'package:zenfit/widgets/session_start_screen.dart';
import 'package:zenfit/db/interfaces/sessions_database_interface.dart';

class HomeScreen extends StatefulWidget {
  final SessionDatabaseInterface? sessionDatabase;
  const HomeScreen({Key? key, this.sessionDatabase}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final sessionDatabase = SessionDatabase();
  List<Session> todaySessions = [];
  List<Session> weekSessions = [];

  @override
  void initState() {
    super.initState();
    getFilteredSessions();
  }

  Future<void> getFilteredSessions() async {
    final sessionList = await sessionDatabase.readAllSessions();

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
                  return GestureDetector(
                    onTap: () async {
                      // Récupérer les exercices associés à la session sélectionnée
                      final sessionWithExercises = await sessionDatabase.readAllSessions();
                      final selectedSession = sessionWithExercises.firstWhere((e) => e.id == session.id);

                      // Passer les exercices de la session à la page d'exécution
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SessionStartScreen(
                            title: selectedSession.name,
                            duration: selectedSession.duration.inMinutes,
                            type: selectedSession.sessionType,
                            exercises: selectedSession.exercises.map((e) {
                              return {
                                'name': e.name,
                                'reps': e.number,
                                'duration': e.duration.inSeconds,
                              };
                            }).toList(),
                          ),
                        ),
                      );
                    },
                    child: _buildSessionTile(session, isToday: true),
                  );
                },
              )
            else
              const Text('Aucune séance pour aujourd\'hui.'),
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
                  return GestureDetector(
                    onTap: () async {
                      // Récupérer les exercices associés à la session sélectionnée
                      final sessionWithExercises = await sessionDatabase.readAllSessions();
                      final selectedSession = sessionWithExercises.firstWhere((e) => e.id == session.id);

                      // Passer les exercices de la session à la page d'exécution
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SessionStartScreen(
                            title: selectedSession.name,
                            duration: selectedSession.duration.inMinutes,
                            type: selectedSession.sessionType,
                            exercises: selectedSession.exercises.map((e) {
                              return {
                                'name': e.name,
                                'reps': e.number,
                                'duration': e.duration.inSeconds,
                              };
                            }).toList(),
                          ),
                        ),
                      );
                    },
                    child: _buildSessionTile(session),
                  );
                },
              )
            else
              const Text('Aucune séance pour cette semaine.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionTile(Session session, {bool isToday = false}) {
    Color themeColor = Theme.of(context).primaryColor;  // Utilisation de la couleur thème actuelle
    return Container(
      decoration: BoxDecoration(
        color: isToday ? themeColor : const Color(0xFFEBE9E9),
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
                  color: isToday ? Colors.white : themeColor,
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
      'Juillet',
      'Août',
      'Sept',
      'Oct',
      'Nov',
      'Déc'
    ];
    return months[month - 1];
  }
}
