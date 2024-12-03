import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zenfit/style/button_style.dart';
import 'package:zenfit/style/text_style.dart';
import 'package:zenfit/style/input_decoration.dart';
import 'package:zenfit/style/icon_theme.dart';
import 'package:zenfit/models/exercises_model.dart';

class EmomWidget extends StatefulWidget {
  final Function(Exercise) onExerciseAdded;

  const EmomWidget({Key? key, required this.onExerciseAdded}) : super(key: key);

  @override
  _EmomWidget createState() => _EmomWidget();
}

class _EmomWidget extends State<EmomWidget> {
  Duration _exerciseTime = Duration(minutes: 1);
  final _formKey = GlobalKey<FormState>();
  String _exerciseName = '';
  int _exerciseNumber = 0;
  String? _selectedExercise;
  final List<String> _exerciseList = ['Abdo', 'Pompe', 'Squat', 'Custom'];

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
                  items: _exerciseList.map((String exercise) {
                    return DropdownMenuItem(
                      value: exercise,
                      child: Text(exercise),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedExercise = value;
                      if (value != 'Custom') {
                        _exerciseName = value ?? '';
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
                  child: const Text('Ajouter Exercice EMOM'),
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