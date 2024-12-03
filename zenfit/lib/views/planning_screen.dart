import 'package:flutter/material.dart';
import 'package:zenfit/style/button_style.dart';
import 'package:zenfit/style/text_style.dart';
import 'package:zenfit/style/input_decoration.dart';
import 'package:zenfit/style/box_decoration.dart';
import 'package:zenfit/style/icon_theme.dart';
import 'package:zenfit/widgets/amrap_widget.dart';
import 'package:zenfit/widgets/hiit_widget.dart';
import 'package:zenfit/widgets/emom_widget.dart';
import 'package:zenfit/widgets/planify_session_widget.dart';
import 'package:zenfit/models/exercices_model.dart';
import 'package:zenfit/models/session_model.dart';

class PlanningScreen extends StatefulWidget {


  const PlanningScreen({Key? key}) : super(key: key);

  @override
  _PlanningScreenState createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {

  final List<Session> sessionList = [];
  String _sessionName = '';
  String? _selectedType;
  Duration _selectedDuration = Duration(minutes: 0);
  List<Exercise> _exercises = [];
  DateTime _sessionDate = DateTime.now();
  int _sessionReminder = 0;

  final List<String> _types = ['AMRAP', 'HIIT', 'EMOM'];

  void _addExercise(Exercise exercise) {
    setState(() {
      _exercises.add(exercise);
    });
  }

  void navigateToPage(BuildContext context) {
    if (_selectedType == 'AMRAP') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AmrapWidget(
          onExerciseAdded: (exercise) => _addExercise(exercise),
        )),
      );
    } else if (_selectedType == 'EMOM') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EmomWidget(
          onExerciseAdded: (exercise) => _addExercise(exercise),
        )),
      );
    } else if (_selectedType == 'HIIT') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HiitWidget(
          onExerciseAdded: (exercise) => _addExercise(exercise),
        )),
      );
    }
  }

  void _selectDuration() async {
    final Duration? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: 0),
    ).then((time) => time != null
        ? Duration(hours: time.hour, minutes: time.minute)
        : null);

    if (picked != null) {
      setState(() {
        _selectedDuration = picked;
      });
    }
  }

  void _validateSeance() {
    if (_selectedType == null || _selectedType!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un type de séance')),
      );
      return;
    }

    if (_exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez ajouter au moins un exercice')),
      );
      return;
    }

    final newSession = Session(
      name: _sessionName,
      sessionType: _selectedType!,
      duration: _selectedDuration,
      exercises: List<Exercise>.from(_exercises),
      date: _sessionDate,
      reminder: _sessionReminder,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlanifySessionWidget(sessionList: sessionList, newSession: newSession)),
    );
  }

  @override
  Widget build(BuildContext context) {
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Ajouter une nouvelle séance', style: ContentTextStyle(context)),
          SizedBox(height: 20),
          DropdownButtonFormField<String>(
            decoration: greyInput(context).copyWith(labelText: 'Type de séance'),
            value: _selectedType,
            items: _types.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedType = value;
                _exercises.clear();
              });
            },
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: _selectDuration,
            child: InputDecorator(
              decoration: greyInput(context).copyWith(
                labelText: 'Durée de la séance',
                suffixIcon: timerIconStyle(context),
              ),
              child: Text(
                '${_selectedDuration.inMinutes} minutes',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: whiteBox(context),
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exercices',
                    style: BleuTitleXSTextStyle(context),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        itemCount: _exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = _exercises[index];
                          return Container(
                            decoration: greyBox(context),
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  exercise.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if ( _selectedType == 'AMRAP' || _selectedType == 'EMOM')
                                  Text(
                                    '${exercise.number} rep',
                                  ),
                                if ( _selectedType == 'HIIT')
                                  Text(
                                    '${exercise.duration.inSeconds} Sec',
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => navigateToPage(context),
                  style: WhiteButtonStyle(context),
                  child: const Text('+ EXERCICE/PAUSE'),
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _validateSeance,
                  style: BleuButtonStyle(context),
                  child: const Text('VALIDER LA SÉANCE'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
