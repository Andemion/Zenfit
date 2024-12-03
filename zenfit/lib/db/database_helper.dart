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
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const textTypeNull = 'TEXT';

    await db.execute('''
      CREATE TABLE user(
        id $idType,
        email $textType,
        password $textType,
      );
      CREATE TABLE sessions (
        id $idType,
        name $textType,
        sessionType $textType,
        duration $intType,
        reminder $intType,
        comment $textTypeNull,
        user_id INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE CASCADE
      );
      CREATE TABLE exercises (
        id $idType,
        name $textType,
        number $intType,
        duration $intType,
      );
      CREATE TABLE session_exercise (
        session_id $idType,
        exercise_id $idType,
        FOREIGN KEY (session_id) REFERENCES sessions (id) ON DELETE CASCADE,
        FOREIGN KEY (exercise_id) REFERENCES exercises (id) ON DELETE CASCADE,
        PRIMARY KEY (session_id, exercise_id)
      );
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
