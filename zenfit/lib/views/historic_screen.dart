import 'package:flutter/material.dart';
import 'package:zenfit/db/sessions_database.dart';
import 'package:zenfit/models/session_model.dart';
import 'package:zenfit/widgets/session_summary_screen.dart'; // Assurez-vous d'avoir cet import

class HistoricScreen extends StatefulWidget {
  const HistoricScreen({Key? key}) : super(key: key);

  @override
  _HistoricScreenState createState() => _HistoricScreenState();
}

class _HistoricScreenState extends State<HistoricScreen> {
  List<Session> sessions = [];

  @override
  void initState() {
    super.initState();
    // Charger les sessions depuis la base de données
    _loadSessions();
  }

  // Méthode pour récupérer les sessions de la base de données
  void _loadSessions() async {
    final allSessions = await SessionDatabase().readAllSessions();
    final validSessions = allSessions.where((session) {
      // Filtrer uniquement les séances passées
      return session.date.isBefore(DateTime.now());
    }).toList();
    
    setState(() {
      sessions = validSessions;
    });
  }

  @override
  Widget build(BuildContext context) {
    for (var session in sessions) {
      print('Session Name: ${session.name}');
      print('Session Type: ${session.sessionType}');
      print('Session Duration: ${session.duration.inMinutes}');
      print('Exercises: ${session.exercises.map((e) => e.name).toList()}');
      print('Comment: ${session.comment}');
    }

    return Scaffold(
      body: SingleChildScrollView(  // Ajout du défilement
        padding: const EdgeInsets.all(16.0),  // Ajout d'un peu de padding autour de la page
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historique des séances',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (sessions.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Icon(
                          Icons.fitness_center,
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        ),
                        title: Text(
                          session.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${session.sessionType} - ${session.date.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).primaryColor,
                        ),
                        onTap: () {
                          // Naviguer vers SummaryScreen avec les données appropriées
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SummaryScreen(
                                sessionName: session.name,
                                type: session.sessionType,
                                sessionDuration: session.duration.inMinutes, // Durée correctement transmise
                                exercises: session.exercises
                                    .map((exercise) => {
                                          'name': exercise.name,
                                          'reps': exercise.number,
                                        })
                                    .toList(),
                                comment: session.comment ?? 'Pas de commentaire',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              )
            else
              const Text('Aucune séance historique disponible.'),
          ],
        ),
      ),
    );
  }
}
