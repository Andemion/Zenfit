import 'dart:async';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseHelperInterface {
  Future<Database> get database; // Getter pour accéder à la base de données
  Future<void> close(); // Méthode pour fermer la base de données
}
