import 'package:zenfit/models/exercises_model.dart';
import 'package:zenfit/db/exercises_database.dart';

Future<void> initializeExercises() async {
  final exerciseDatabase = ExerciseDatabase();

  // Vérifier si des exercices existent déjà
  final existingExercises = await exerciseDatabase.readAllExercises();

  if (existingExercises.isEmpty) {
    // Insérer des exercices par défaut1
    final defaultExercises = [
      Exercise(name: 'Jumping Jacks', number: 10, duration: Duration(seconds: 0)),
      Exercise(name: 'Push-ups', number: 10, duration: Duration(seconds: 0)),
      Exercise(name: 'Custom', number: 0, duration: Duration(seconds: 0)),
    ];

    for (final exercise in defaultExercises) {
      await exerciseDatabase.createExercise(exercise);
    }

    print('Exercices par défaut insérés dans la base de données.');
  } else {
    print('Exercices déjà existants. Aucun ajout nécessaire.');
  }
}
