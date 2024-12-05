import 'package:zenfit/models/exercises_model.dart';
import 'package:zenfit/db/interfaces/exercise_database_interface.dart';
import 'database_helper.dart';

class ExerciseDatabase implements ExerciseDatabaseInterface {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<int?> findExerciseIdByName(String name) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'exercises',
      where: 'name = ?',
      whereArgs: [name],
      limit: 1,
    );

    return result.isNotEmpty ? result.first['id'] as int : null;
  }

  // CREATE : Ajouter un nouvel exercice
  Future<int?> saveExerciseIfNotExists(Exercise exercise) async {
    final db = await DatabaseHelper.instance.database;

    // Vérifiez si l'exercice existe déjà
    final existsId = await findExerciseIdByName(exercise.name);

    if (existsId == null) {
      // Si l'exercice n'existe pas, insérez-le dans la base de données
      await db.insert('exercises', {
        'name': exercise.name,
        'number': exercise.number,
        'duration': exercise.duration.inSeconds, // Sauvegarder la durée en secondes
      });
      print(exercise.name);
      print('Exercice sauvegardé dans la base de données.');
      return findExerciseIdByName(exercise.name);
    } else {
        updateExercise(existsId, exercise);
        print('Exercice update dans la base de données.');
      return existsId;
    }
  }

  // READ : Lire un exercice par son ID
  Future<Exercise?> readExercise(int id) async {
    final db = await dbHelper.database;

    // Rechercher l'exercice par son ID
    final maps = await db.query(
      'exercises',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Exercise.fromJson(maps.first);
    }
    return null; // Retourne null si l'exercice n'est pas trouvé
  }

  // READ : Lire tous les exercices
  Future<List<Exercise>> readAllExercises() async {
    final db = await dbHelper.database;

    // Lire tous les exercices
    final result = await db.query('exercises');

    // Convertir les résultats en liste d'objets Exercise
    return result.map((json) => Exercise.fromJson(json)).toList();
  }

  // UPDATE : Mettre à jour un exercice
  Future<void> updateExercise(int id, Exercise exercise) async {
    final db = await DatabaseHelper.instance.database;

    final updates = <String, dynamic>{};

    if (exercise.number > 0) {
      updates['number'] = exercise.number;
    }

    if (exercise.duration.inSeconds > 0) {
      updates['duration'] = exercise.duration.inSeconds;
    }

    if (updates.isNotEmpty) {
      await db.update(
        'exercises',
        updates,
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Exercice mis à jour avec succès.');
    }
  }

  // DELETE : Supprimer un exercice
  Future<int> deleteExercise(int id) async {
    final db = await dbHelper.database;

    // Supprimer l'exercice
    return await db.delete(
      'exercises',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
