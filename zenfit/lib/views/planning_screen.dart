import 'package:flutter/material.dart';
import 'package:zenfit/widgets/style/button_style.dart';
import 'package:zenfit/widgets/style/text_style.dart';
import 'package:zenfit/widgets/style/input_decoration.dart';
import 'package:zenfit/widgets/style/box_decoration.dart';

class PlanningScreen extends StatefulWidget {
  @override
  _PlanningScreenState createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  String? _selectedType;
  Duration _selectedDuration = Duration(minutes: 0);
  List<String> _exercises = [];

  final List<String> _types = ['AMRAP', 'HIIT', 'EMON'];

  void _addExercise() {
    setState(() {
      _exercises.add("Nouvel exercice ${_exercises.length + 1}");
    });
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
    // Logique pour valider la séance
    print("Séance validée : type $_selectedType, durée $_selectedDuration, exercices $_exercises");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Text('Nouvelle séance', style: TitleStyle),
          // SizedBox(height: 5),
          Text('Ajouter une nouvelle séance à votre programme', style: ContentTextStyle),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            decoration: greyInput.copyWith(
              labelText: 'Type de séance'
            ),
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
              });
            },
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: _selectDuration,
            child: InputDecorator(
              decoration: greyInput.copyWith(
                labelText: 'Durée de la séance',
                suffixIcon: Icon(Icons.timer, color: Color(0xFF1A43EE))
              ),
              child: Text(
                '${_selectedDuration.inMinutes} minutes',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: whiteBox,
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exercices',
                    style: BleuTitleXSTextStyle,
                  ),
                  SizedBox(height: 8),
                  // Liste des exercices (vide dans cet exemple, mais vous pouvez la remplir dynamiquement)
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        itemCount: 5, // Nombre d'exercices (pour l'exemple)
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: greyBox,
                              child: Text(
                                'Exercice ${index + 1}',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                    )
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
                  onPressed: _addExercise,
                  style: WhiteButtonStyle,
                  child: const Text('+ EXERCICE/PAUSE'),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _validateSeance,
                  style: BleuButtonStyle,
                  child: const Text('VALIDER LA SÉANCE'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
