import 'package:zenfit/models/session_model.dart';
import 'package:zenfit/models/exercises_model.dart';
import 'database_helper.dart';
import 'package:zenfit/db/interfaces/sessions_database_interface.dart';

class SessionDatabase implements SessionDatabaseInterface {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  // CREATE : Ajouter une nouvelle session
  Future<int> createSession(Session session) async {
    final db = await dbHelper.database;

    // Insérer la session dans la table sessions
    final sessionId = await db.insert('sessions', session.toJson());

    if (sessionId > 0) {
      print('Session enregistrée avec succès. ID de la session : $sessionId');
    } else {
      print('Erreur lors de l\'enregistrement de la session.');
    }

    // Insérer les relations entre la session et les exercices
    for (final exercise in session.exercises) {
      await db.insert('session_exercise', {
        'session_id': sessionId,
        'exercise_id': exercise.id,
      });
    }

    return sessionId;
  }

  // READ : Lire toutes les sessions
  Future<List<Session>> readAllSessions() async {
    final db = await dbHelper.database;

    // Lire toutes les sessions
    final sessionMaps = await db.query('sessions');

    // Lire les relations session_exercise et récupérer les exercices pour chaque session
    List<Session> sessions = [];
    for (final sessionMap in sessionMaps) {
      final sessionId = sessionMap['id'] as int;

      // Récupérer les exercices associés à la session
      final exerciseMaps = await db.rawQuery('''
        SELECT exercises.* FROM exercises
        INNER JOIN session_exercise ON exercises.id = session_exercise.exercise_id
        WHERE session_exercise.session_id = ?
      ''', [sessionId]);

      final exercises = exerciseMaps.map((e) => Exercise.fromJson(e)).toList();

      // Ajouter la session avec ses exercices
      sessions.add(Session.fromJson(sessionMap, exercises));
    }

    return sessions;
  }

  // UPDATE : Mettre à jour une session
  Future<int> updateSession(Session session) async {
    final db = await dbHelper.database;

    // Mettre à jour les informations de la session
    final result = await db.update(
      'sessions',
      session.toJson(),
      where: 'id = ?',
      whereArgs: [session.id],
    );

    // Supprimer les anciennes relations session-exercice
    await db.delete(
      'session_exercise',
      where: 'session_id = ?',
      whereArgs: [session.id],
    );

    // Insérer les nouvelles relations session-exercice
    for (final exercise in session.exercises) {
      await db.insert('session_exercise', {
        'session_id': session.id,
        'exercise_id': exercise.id,
      });
    }

    return result;
  }

  // DELETE : Supprimer une session
  Future<int> deleteSession(int sessionId) async {
    final db = await dbHelper.database;

    // Supprimer les relations session-exercice
    await db.delete(
      'session_exercise',
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );

    // Supprimer la session elle-même
    return await db.delete(
      'sessions',
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }
}
