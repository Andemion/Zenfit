import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:zenfit/views/home_screen.dart';
import 'mock.mocks.dart';
import 'package:zenfit/models/session_model.dart';
import 'package:zenfit/models/exercises_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialiser SQLite pour les tests
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('HomeScreen Tests', () {
    late MockSessionDatabaseInterface mockSessionDatabase;

    setUp(() {
      mockSessionDatabase = MockSessionDatabaseInterface();
    });

    testWidgets('should filter today and week sessions correctly', (WidgetTester tester) async {
      // Créer une liste de sessions factices
      final fakeSessions = [
        Session(
          id: 1,
          name: 'Morning Workout',
          sessionType: 'Strength',
          duration: Duration(minutes: 60),
          exercises: [
            Exercise(id: 1, name: 'Push Up', number: 10, duration: Duration(seconds: 30)),
          ],
          date: DateTime.now(), // Aujourd'hui
          reminder: 0,
          comment: 'Focus on upper body',
        ),
        Session(
          id: 2,
          name: 'Cardio Blast',
          sessionType: 'Cardio',
          duration: Duration(minutes: 45),
          exercises: [
            Exercise(id: 2, name: 'Jumping Jacks', number: 20, duration: Duration(seconds: 15)),
          ],
          date: DateTime.now().subtract(Duration(days: 2)), // Cette semaine
          reminder: 1,
          comment: 'Maintain steady pace',
        ),
        Session(
          id: 3,
          name: 'Yoga Session',
          sessionType: 'Flexibility',
          duration: Duration(minutes: 30),
          exercises: [
            Exercise(id: 3, name: 'Downward Dog', number: 1, duration: Duration(minutes: 2)),
          ],
          date: DateTime.now().add(Duration(days: 7)), // Pas cette semaine
          reminder: 0,
          comment: 'Relax and stretch',
        ),
      ];

      // Stub de la méthode readAllSessions
      when(mockSessionDatabase.readAllSessions()).thenAnswer((_) async => fakeSessions);

      // Construire le widget en injectant le mock
      await tester.pumpWidget(MaterialApp(
        home: HomeScreen(sessionDatabase: mockSessionDatabase),
      ));

      // Attendre que le widget soit entièrement chargé
      await tester.pumpAndSettle();

      // Vérifier les résultats visuels ou comportementaux
      expect(find.text('Morning Workout'), findsOneWidget); // Vérifiez que la session d'aujourd'hui est affichée
      expect(find.text('Cardio Blast'), findsOneWidget); // Vérifiez que la session de la semaine est affichée
      expect(find.text('Yoga Session'), findsNothing); // Vérifiez que la session hors de la semaine n'est pas affichée
    });
  });
}
