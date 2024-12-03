import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const textTypeNull = 'TEXT';

    // Activer les clés étrangères
    await db.execute('PRAGMA foreign_keys = ON');

    // Supprimer les tables si elles existent (optionnel)
    // await db.execute('DROP TABLE IF EXISTS session_exercise');
    // await db.execute('DROP TABLE IF EXISTS exercises');
    // await db.execute('DROP TABLE IF EXISTS sessions');
    // await db.execute('DROP TABLE IF EXISTS user');

    // Création des tables
    await db.execute('''
      CREATE TABLE user (
        id $idType,
        email $textType,
        password $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE sessions (
        id $idType,
        name $textType,
        sessionType $textType,
        duration $intType,
        date $textType,
        reminder $intType,
        comment $textTypeNull
      )
    ''');
    // user_id INTEGER NOT NULL,
    // FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE CASCADE
    await db.execute('''
      CREATE TABLE exercises (
        id $idType,
        name $textType,
        number $intType,
        duration $intType
      )
    ''');

    await db.execute('''
      CREATE TABLE session_exercise (
        session_id INTEGER NOT NULL,
        exercise_id INTEGER NOT NULL,
        FOREIGN KEY (session_id) REFERENCES sessions (id) ON DELETE CASCADE,
        FOREIGN KEY (exercise_id) REFERENCES exercises (id) ON DELETE CASCADE,
        PRIMARY KEY (session_id, exercise_id)
      )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Appliquer les modifications pour la mise à jour
      // Exemple : Ajouter une colonne dans une table existante
      await db.execute('ALTER TABLE user ADD COLUMN phone TEXT');
    }
  }

  Future close() async {
    final db = await instance.database;
    if (db.isOpen) {
      await db.close();
    }
  }
}
