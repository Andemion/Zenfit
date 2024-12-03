import 'package:zenfit/models/user_model.dart';
import 'package:zenfit/models/session_model.dart';
import 'database_helper.dart';

class UserDatabase {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  // CREATE : Ajouter un nouvel utilisateur
  Future<int> createUser(User user) async {
    final db = await dbHelper.database;

    // Insérer l'utilisateur dans la table user
    final userId = await db.insert('user', user.toJson());

    // Insérer les sessions associées à l'utilisateur
    if (user.sessions != null) {
      for (final session in user.sessions!) {
        await db.insert('sessions', {
          ...session.toJson(),
          'user_id': userId, // Ajouter l'utilisateur associé
        });
      }
    }

    return userId;
  }

  // READ : Lire un utilisateur et ses sessions
  Future<User?> readUser(int id) async {
    final db = await dbHelper.database;

    // Lire l'utilisateur
    final userMaps = await db.query(
      'user',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (userMaps.isEmpty) return null;

    // Lire les sessions associées à cet utilisateur
    final sessionMaps = await db.query(
      'sessions',
      where: 'user_id = ?',
      whereArgs: [id],
    );

    final sessions = sessionMaps.map((s) => Session.fromJson(s, [])).toList();

    return User.fromJson(userMaps.first, sessions);
  }

  // READ : Lire tous les utilisateurs
  Future<List<User>> readAllUsers() async {
    final db = await dbHelper.database;

    // Lire tous les utilisateurs
    final userMaps = await db.query('user');

    // Récupérer les sessions associées à chaque utilisateur
    List<User> users = [];
    for (final userMap in userMaps) {
      final userId = userMap['id'] as int;

      final sessionMaps = await db.query(
        'sessions',
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      final sessions = sessionMaps.map((s) => Session.fromJson(s, [])).toList();
      users.add(User.fromJson(userMap, sessions));
    }

    return users;
  }

  // UPDATE : Mettre à jour un utilisateur
  Future<int> updateUser(User user) async {
    final db = await dbHelper.database;

    // Mettre à jour l'utilisateur
    final result = await db.update(
      'user',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );

    // Optionnel : Vous pouvez également mettre à jour les sessions associées ici

    return result;
  }

  // DELETE : Supprimer un utilisateur
  Future<int> deleteUser(int id) async {
    final db = await dbHelper.database;

    // Supprimer toutes les sessions associées à cet utilisateur
    await db.delete(
      'sessions',
      where: 'user_id = ?',
      whereArgs: [id],
    );

    // Supprimer l'utilisateur lui-même
    return await db.delete(
      'user',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
