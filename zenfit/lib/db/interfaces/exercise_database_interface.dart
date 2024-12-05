import 'package:zenfit/models/exercises_model.dart';

abstract class ExerciseDatabaseInterface {
  Future<int?> findExerciseIdByName(String name);
  Future<void> saveExerciseIfNotExists(Exercise exercise);
  Future<Exercise?> readExercise(int id);
  Future<List<Exercise>> readAllExercises();
  Future<void> updateExercise(int id, Exercise exercise);
  Future<int> deleteExercise(int id);
}