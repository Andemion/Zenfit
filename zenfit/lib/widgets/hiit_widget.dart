import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zenfit/style/button_style.dart';
import 'package:zenfit/style/text_style.dart';
import 'package:zenfit/style/input_decoration.dart';
import 'package:zenfit/style/icon_theme.dart';
import 'package:zenfit/models/exercises_model.dart';
import 'package:zenfit/db/exercises_database.dart';

class HiitWidget extends StatefulWidget {
  final Function(Exercise) onExerciseAdded;

  const HiitWidget({Key? key, required this.onExerciseAdded}) : super(key: key);

  @override
  _HiitWidget createState() => _HiitWidget();
}

class _HiitWidget extends State<HiitWidget> {
  final exerciseDatabase = ExerciseDatabase();
  final FixedExtentScrollController _pickerController = FixedExtentScrollController();
  final _formKey = GlobalKey<FormState>();
  List<Exercise> exerciseList = [];
  bool _isCustomExercise = false;
  Duration _exerciseTime = Duration(minutes: 0);
  String _exerciseName = '';
  int _exerciseNumber = 0;
  int? _selectedExerciseId;

  @override
  void initState() {
    super.initState();
    getExercises();
  }

  @override
  void dispose() {
    _pickerController.dispose();
    super.dispose();
  }

  Future<void> getExercises() async {
    final exercisesDB = await exerciseDatabase.readAllExercises();
    setState(() {
      exerciseList = exercisesDB;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HIIT Configuration',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: whiteIcon(context),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                DropdownButtonFormField<int>(
                  decoration: greyInput(context).copyWith(
                    labelText: "Sélectionnez un exercice",
                  ),
                  value: _selectedExerciseId, // Utiliser l'id comme valeur
                  items: exerciseList.map((exercise) {
                    return DropdownMenuItem<int>(
                      value: exercise.id, // La valeur sera l'id de l'exercice
                      child: Text('${exercise.name} / ${exercise.duration.inSeconds} Sec'),
                    );
                  }).toList(),
                  onChanged: (int? id) {
                    setState(() {
                      _selectedExerciseId = id; // Mettre à jour l'id sélectionné
                      if (id != null) {
                        // Trouver l'exercice correspondant à l'id
                        final selectedExercise = exerciseList.firstWhere((exercise) => exercise.id == id);

                        _exerciseName = selectedExercise.name;
                        _isCustomExercise = _exerciseName == "Custom";
                        // Mettre à jour le temps de l'exercice
                        _exerciseTime = selectedExercise.duration;
                        // Mettre à jour la position du picker
                        final pickerIndex = _exerciseTime.inSeconds ~/ 5;
                        _pickerController.jumpToItem(pickerIndex);
                      } else {
                        _exerciseName = '';
                        _isCustomExercise = false;
                        _exerciseTime = Duration.zero; // Réinitialiser si aucun exercice sélectionné
                        _pickerController.jumpToItem(0);
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez sélectionner un exercice';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: _isCustomExercise,
                  child: TextFormField(
                    decoration: greyInput(context).copyWith(
                      labelText: "Nom de l'exercice (personnalisé)",
                    ),
                    onChanged: (String value) {
                      setState(() {
                        _exerciseName = value;
                      });
                    },
                    validator: (String? value) {
                      if (_selectedExerciseId == null && (value == null || value.isEmpty)) {
                        return 'Veuillez entrer un nom pour l\'exercice';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200.0,
                  child: CupertinoPicker(
                    scrollController: _pickerController,
                    itemExtent: 32.0,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _exerciseTime = Duration(seconds: index * 5);
                      });
                    },
                    children: List<Widget>.generate(12 * 12, (int index) {
                      final seconds = index * 5;
                      return Center(
                        child: Text('${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}'),
                      );
                    }),
                  ),
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
                      final pause = Exercise(
                        name: "Pause",
                        number: _exerciseNumber,
                        duration: _exerciseTime,
                      );

                      // Sauvegarde l'exercice si non existant
                      exerciseDatabase.saveExerciseIfNotExists(newExercise);
                      widget.onExerciseAdded(newExercise);
                      widget.onExerciseAdded(pause);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Ajouter Exercice HIIT'),
                  style: BleuButtonStyle(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
