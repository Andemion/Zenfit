import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'mock.mocks.dart';
import 'package:zenfit/db/initialize_exercises.dart';
import 'package:zenfit/db/interfaces/exercise_database_interface.dart';

void main() {
  group('initializeExercises', () {
    late MockExerciseDatabaseInterface mockDatabase;

    setUp(() {
      mockDatabase = MockExerciseDatabaseInterface();

      // Configure le comportement simulé pour findExerciseIdByName
      when(mockDatabase.findExerciseIdByName(any)).thenAnswer((_) async => null);

      // Configure le comportement simulé pour saveExerciseIfNotExists
      when(mockDatabase.saveExerciseIfNotExists(any)).thenAnswer((_) async {});

      // Configure le comportement simulé pour readAllExercises
      when(mockDatabase.readAllExercises()).thenAnswer((_) async => []);
    });

    test('should save all exercises if they do not exist', () async {
      await initializeExercises(mockDatabase);


      // Vérifiez que readAllExercises a été appelé une fois
      verify(mockDatabase.readAllExercises()).called(1);

      // Vérifiez que saveExerciseIfNotExists a été appelé 3 fois
      verify(mockDatabase.saveExerciseIfNotExists(any)).called(3);

      // Assurez-vous qu'il n'y a pas d'autres appels
      verifyNoMoreInteractions(mockDatabase);
    });
  });
}
