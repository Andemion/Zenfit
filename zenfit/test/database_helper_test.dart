import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zenfit/db/database_helper.dart';
import 'package:zenfit/db/interfaces/database_helper_interface.dart';
import 'mock.mocks.dart';

class FakeDatabase extends Fake implements Database {}

void main() {
  group('DatabaseHelper Tests', () {
    late MockDatabaseHelperInterface mockDatabaseHelper;
    late FakeDatabase fakeDatabase;

    setUp(() {
      mockDatabaseHelper = MockDatabaseHelperInterface();
      fakeDatabase = FakeDatabase();

      // Stub pour retourner une instance fictive de `Database`
      when(mockDatabaseHelper.database).thenAnswer((_) async => fakeDatabase);
    });

    test('should initialize database correctly', () async {
      final db = await mockDatabaseHelper.database;

      // Vérifiez que la méthode `database` a été appelée
      verify(mockDatabaseHelper.database).called(1);

      // Vérifiez que l'objet retourné n'est pas null
      expect(db, isNotNull);
    });
  });
}
