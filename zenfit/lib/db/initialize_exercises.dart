import 'package:zenfit/models/exercises_model.dart';
import 'package:zenfit/db/exercises_database.dart';
import 'package:zenfit/db/interfaces/exercise_database_interface.dart';

Future<void> initializeExercises(ExerciseDatabaseInterface exerciseDatabase) async {
  //final exerciseDatabase = ExerciseDatabase();

  // Vérifier si des exercices existent déjà
  final existingExercises = await exerciseDatabase.readAllExercises();

  if (existingExercises.isEmpty) {
    // Insérer des exercices par défaut1
    final defaultExercises = [
      Exercise(name: 'Custom', number: 0, duration: Duration(seconds: 30)),
      Exercise(name: 'Jumping Jacks', number: 20, duration: Duration(seconds: 30)),
      Exercise(name: 'Push-ups', number: 20, duration: Duration(seconds: 30)),

    ];

    for (final exercise in defaultExercises) {
      await exerciseDatabase.saveExerciseIfNotExists(exercise);
    }

    print('Exercices par défaut insérés dans la base de données.');
  } else {
    print('Exercices déjà existants. Aucun ajout nécessaire.');
  }
}
