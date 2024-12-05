import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:zenfit/widgets/session_summary_screen.dart';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:zenfit/widgets/session_summary_screen.dart';

class SessionEndScreen extends StatefulWidget {
  final String type; // Type de séance : AMRAP, HIIT, EMON
  final String sessionName; // Nom de la séance
  final List<Map<String, dynamic>> exercises; // Liste des exercices avec répétitions initiales
  final int sessionDuration;

  const SessionEndScreen({
    Key? key,
    required this.type,
    required this.sessionName,
    required this.exercises,
    required this.sessionDuration,
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
      repetitions = widget.exercises.map<int>((exercise) => exercise['reps']).toList(); // Répétitions pour AMRAP
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

  void saveSession() {
    // Préparer les données des exercices avec les répétitions
    List<Map<String, dynamic>> updatedExercises = widget.exercises.map((exercise) {
      int index = widget.exercises.indexOf(exercise);
      return {
        'name': exercise['name'],
        'reps': repetitions[index],
      };
    }).toList();

    // Naviguer vers SummaryScreen avec les données de la séance
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryScreen(
          sessionName: widget.sessionName,
          type: widget.type,
          seriesCount: widget.type == 'AMRAP' ? seriesCount : null,
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
                SizedBox(height: 20),

                Text(
                  'Répétitions par exercice',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                for (int i = 0; i < widget.exercises.length; i++) ...[
                  Text(
                    widget.exercises[i]['name'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (repetitions[i] > 0) repetitions[i]--;
                            });
                          },
                          icon: Icon(Icons.remove),
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          '${repetitions[i]}',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              repetitions[i]++;
                            });
                          },
                          icon: Icon(Icons.add),
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ],

              // Section HIIT et EMON : Répétitions
              if (widget.type == 'HIIT' || widget.type == 'EMOM') ...[
                Text(
                  'Répétitions par exercice',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                for (int i = 0; i < widget.exercises.length; i++) ...[
                  Text(
                    widget.exercises[i]['name'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (repetitions[i] > 0) repetitions[i]--;
                            });
                          },
                          icon: Icon(Icons.remove),
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          '${repetitions[i]}',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              repetitions[i]++;
                            });
                          },
                          icon: Icon(Icons.add),
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ],

              // Section pour ajouter un commentaire
              Text(
                'Ajouter un commentaire',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Commentaire...',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isListening ? Icons.mic_off : Icons.mic,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: _isListening ? _stopListening : _startListening,
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: saveSession,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    'Enregistrer la séance',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
