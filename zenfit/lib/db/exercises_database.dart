import 'package:zenfit/models/exercises_model.dart';
import 'database_helper.dart';

class ExerciseDatabase {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  // CREATE : Ajouter un nouvel exercice
  Future<int> createExercise(Exercise exercise) async {
    final db = await dbHelper.database;

    // Insérer l'exercice dans la table exercises
    return await db.insert('exercises', exercise.toJson());
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
  Future<int> updateExercise(Exercise exercise) async {
    final db = await dbHelper.database;

    // Mettre à jour l'exercice
    return await db.update(
      'exercises',
      exercise.toJson(),
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
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
