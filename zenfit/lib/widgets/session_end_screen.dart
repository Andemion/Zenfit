import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:zenfit/widgets/session_summary_screen.dart';
import 'package:zenfit/models/session_model.dart';
import 'package:zenfit/models/exercises_model.dart';
import 'package:zenfit/db/sessions_database.dart';

class SessionEndScreen extends StatefulWidget {
  final String type; // Type de séance : AMRAP, HIIT, EMON
  final String sessionName; // Nom de la séance
  final List<Map<String, dynamic>> exercises; // Liste des exercices avec répétitions initiales
  final int sessionDuration;
  final int? sessionId; // ID de la session à mettre à jour
  final int sessionReminder;
  final DateTime sessionDate;

  const SessionEndScreen({
    Key? key,
    required this.type,
    required this.sessionName,
    required this.exercises,
    required this.sessionDuration,
    required this.sessionId, // ID de la session
    required this.sessionReminder,
    required this.sessionDate,
  }) : super(key: key);

  @override
  _SessionEndScreenState createState() => _SessionEndScreenState();
}

class _SessionEndScreenState extends State<SessionEndScreen> {
  late int seriesCount; // Nombre de séries (AMRAP)
  late List<int> repetitions; // Répétitions par exercice
  final TextEditingController _commentController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    seriesCount = 0; // Initialisation des séries pour AMRAP
    
    // Initialisation des répétitions
    if (widget.type == 'AMRAP') {
      repetitions = widget.exercises.map<int>((exercise) => exercise['reps'] ?? 0).toList(); // Répétitions pour AMRAP, avec sécurité contre null
    } else {
      repetitions = List.filled(widget.exercises.length, 0); // Initialisation des répétitions à 0 pour HIIT et EMON
    }
    _speech = stt.SpeechToText(); // Initialisation de la reconnaissance vocale
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _commentController.text = result.recognizedWords;
          });
        },
      );
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  // Fonction pour enregistrer la session avec mise à jour dans la base de données
  void saveSession() async {
    // Préparer les données des exercices avec les répétitions
    List<Map<String, dynamic>> updatedExercises = widget.exercises.map((exercise) {
      int index = widget.exercises.indexOf(exercise);
      // Vérification pour éviter les nulls dans 'reps'
      int reps = repetitions[index];

      return {
        'name': exercise['name'] ?? 'Inconnu',
        'reps': reps, // Répétitions mises à jour
      };
    }).toList();

    // Créer une nouvelle session avec les données mises à jour
    final updatedSession = Session(
      id: widget.sessionId ?? 0, // L'ID de la session que nous mettons à jour (valeur par défaut 0 si null)
      date: DateTime.now(), // Vous pouvez ajuster ceci pour prendre en compte la date de la session
      reminder: widget.sessionReminder,
      name: widget.sessionName,
      duration: Duration(seconds: widget.sessionDuration ?? 0), // Conversion correcte de la durée
      sessionType: widget.type,
      exercises: updatedExercises.map((e) {
        return Exercise(
          id: e['id'] ?? 0, // Assurez-vous que 'id' existe, sinon utiliser une valeur par défaut
          name: e['name'] ?? 'Inconnu', // Nom de l'exercice, valeur par défaut si null
          number: e['number'] ?? 0, // Valeur par défaut si 'number' est null
          duration: Duration(seconds: e['duration'] ?? 0), // Assurez-vous que 'duration' existe, sinon valeur par défaut
        );
      }).toList(),
      comment: _commentController.text,
    );

    // Utiliser la méthode updateSession pour mettre à jour la session dans la base de données
    await SessionDatabase().updateSession(updatedSession);

    // Ajouter un print pour vérifier l'objet de la session après mise à jour
    print('Session mise à jour : ${updatedSession.toJson()}');

    // Naviguer vers SummaryScreen avec les données de la séance
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryScreen(
          sessionName: widget.sessionName,
          type: widget.type,

          exercises: updatedExercises,
          comment: _commentController.text,
          sessionDuration: widget.sessionDuration,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sessionName, style: const TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bravo pour votre séance !',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),

              // Section AMRAP : Séries et répétitions
              if (widget.type == 'AMRAP') ...[
                Text(
                  'Séries réalisées',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (seriesCount > 0) {
                            setState(() => seriesCount--);
                          }
                        },
                        icon: const Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        '$seriesCount',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () => setState(() => seriesCount++),
                        icon: const Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 30),

              // Exercices et boutons de répétition
              Text(
                'Répétitions par exercice',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Column(
                children: List.generate(widget.exercises.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Text(
                          widget.exercises[index]['name'],
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (repetitions[index] > 0) repetitions[index]--;
                            });
                          },
                          icon: Icon(Icons.remove),
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          '${repetitions[index]}',
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              repetitions[index]++;
                            });
                          },
                          icon: Icon(Icons.add),
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  );
                }),
              ),

              SizedBox(height: 20),

              // Commentaire
              TextField(
                controller: _commentController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Ajouter un commentaire',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 30),

              // Bouton d'enregistrement
              ElevatedButton(
                onPressed: saveSession,
                child: Text('Enregistrer la session'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
