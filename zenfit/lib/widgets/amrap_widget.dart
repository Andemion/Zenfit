import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zenfit/style/button_style.dart';
import 'package:zenfit/style/text_style.dart';
import 'package:zenfit/style/input_decoration.dart';
import 'package:zenfit/style/icon_theme.dart';
import 'package:zenfit/models/exercises_model.dart';
import 'package:zenfit/db/exercises_database.dart';

class AmrapWidget extends StatefulWidget {
  final Function(Exercise) onExerciseAdded;

  const AmrapWidget({Key? key, required this.onExerciseAdded}) : super(key: key);

  @override
  _AmrapWidget createState() => _AmrapWidget();
}

class _AmrapWidget extends State<AmrapWidget> {

  final exerciseDatabase = ExerciseDatabase();
  List<Exercise> exerciseList = [];

  @override
  void initState() {
    super.initState();
    getExercises();
  }

  Future<void> getExercises() async {
    final exercisesDB = await exerciseDatabase.readAllExercises();
    setState(() {
      exerciseList = exercisesDB;
    });
  }

  Duration _exerciseTime = Duration(minutes: 0);
  final _formKey = GlobalKey<FormState>();
  String _exerciseName = '';
  int _exerciseNumber = 0;
  String? _selectedExercise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AMRAP Configuration',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: whiteIcon,
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: greyInput.copyWith(
                    labelText: "Sélectionnez un exercice",
                  ),
                  value: _selectedExercise,
                  items: exerciseList.map((exercise) {
                    return DropdownMenuItem<String>(
                      value: exercise.name, // La valeur sera le nom de l'exercice
                      child: Text('${exercise.name} / ${exercise.number} rep'),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedExercise = value;
                      if (value != null && value != 'Custom') {
                        _exerciseName = value;
                      } else {
                        _exerciseName = '';
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner un exercice';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: _selectedExercise == 'Custom',
                  child: TextFormField(
                    decoration: greyInput.copyWith(
                      labelText: "Nom de l'exercice (personnalisé)",
                    ),
                    onChanged: (String value) {
                      setState(() {
                        _exerciseName = value;
                      });
                    },
                    validator: (String? value) {
                      if (_selectedExercise == 'Custom' && (value == null || value.isEmpty)) {
                        return 'Veuillez entrer un nom pour l\'exercice';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: greyInput.copyWith(
                    labelText: 'Nombre de répétitions',
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _exerciseNumber = int.tryParse(value) ?? 0;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nombre';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Veuillez entrer un nombre valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newExercise = Exercise(
                        name: _exerciseName,
                        number: _exerciseNumber,
                        duration: _exerciseTime,
                      );
                      widget.onExerciseAdded(newExercise);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Ajouter Exercice AMRAP'),
                  style: BleuButtonStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
