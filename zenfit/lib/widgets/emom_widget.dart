import 'package:flutter/material.dart';
import 'package:zenfit/style/button_style.dart';
import 'package:zenfit/style/text_style.dart';
import 'package:zenfit/style/input_decoration.dart';
import 'package:zenfit/style/icon_theme.dart';
import 'package:zenfit/models/exercises_model.dart';
import 'package:zenfit/db/exercises_database.dart';

class EmomWidget extends StatefulWidget {
  final Function(Exercise) onExerciseAdded;

  const EmomWidget({Key? key, required this.onExerciseAdded}) : super(key: key);

  @override
  _EmomWidget createState() => _EmomWidget();
}

class _EmomWidget extends State<EmomWidget> {
  final TextEditingController _repetitionController = TextEditingController();
  final exerciseDatabase = ExerciseDatabase();
  final _formKey = GlobalKey<FormState>();
  List<Exercise> exerciseList = [];
  bool _isCustomExercise = false;
  Duration _exerciseTime = Duration(minutes: 1);
  String _exerciseName = '';
  int _exerciseNumber = 0;
  int? _selectedExerciseId;

  @override
  void initState() {
    super.initState();
    getExercises();
    _repetitionController.text = _exerciseNumber.toString();
  }

  @override
  void dispose() {
    _repetitionController.dispose();
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
          'EMOM Configuration',
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
                      child: Text('${exercise.name} / ${exercise.number} rep'),
                    );
                  }).toList(),
                  onChanged: (int? id) {
                    setState(() {
                      _selectedExerciseId = id; // Mettre à jour l'id sélectionné
                      if (id != null) {
                        // Trouver l'exercice correspondant à l'id
                        final selectedExercise =
                        exerciseList.firstWhere((exercise) => exercise.id == id);
                        _exerciseName = selectedExercise.name;
                        _exerciseNumber = selectedExercise.number;
                        _isCustomExercise = _exerciseName == "Custom";
                        // Mettre à jour le contrôleur pour afficher les répétitions sélectionnées
                        _repetitionController.text = _exerciseNumber.toString();
                      } else {
                        _exerciseName = '';
                        _exerciseNumber = 0; // Réinitialiser pour "Custom"
                        _isCustomExercise = false;
                        _repetitionController.text = ''; // Réinitialiser le contrôleur
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
                TextFormField(
                  controller: _repetitionController, // Utiliser le contrôleur
                  keyboardType: TextInputType.number,
                  decoration: greyInput(context).copyWith(
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
                  onPressed: () async {  // Marquer cette fonction comme 'async'
                    if (_formKey.currentState!.validate()) {if (_selectedExerciseId == 1) {
                          _selectedExerciseId = null;
                        }
                      final newExercise = Exercise(
                        id: _selectedExerciseId, // Ajouter l'id sélectionné
                        name: _exerciseName,
                        number: _exerciseNumber,
                        duration: _exerciseTime,
                      );

                      // Sauvegarde l'exercice si non existant
                      final savedId = await exerciseDatabase.saveExerciseIfNotExists(newExercise);
                      newExercise.id = savedId; // Assigner l'ID après la sauvegarde
                      widget.onExerciseAdded(newExercise);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Ajouter Exercice EMOM'),
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
