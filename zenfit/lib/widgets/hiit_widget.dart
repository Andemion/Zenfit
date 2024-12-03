import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zenfit/style/button_style.dart';
import 'package:zenfit/style/text_style.dart';
import 'package:zenfit/style/input_decoration.dart';
import 'package:zenfit/style/icon_theme.dart';
import 'package:zenfit/models/exercices_model.dart';

class HiitWidget extends StatefulWidget {
  final Function(Exercise) onExerciseAdded;

  const HiitWidget({Key? key, required this.onExerciseAdded}) : super(key: key);

  @override
  _HiitWidget createState() => _HiitWidget();
}

class _HiitWidget extends State<HiitWidget> {
  Duration _exerciseTime = Duration(minutes: 0);
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
          'HIIT Configuration',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: whiteIcon(context),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200.0,
            child: CupertinoPicker(
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
          Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: greyInput(context).copyWith(
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
                    decoration: greyInput(context).copyWith(
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
