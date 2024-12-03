import 'package:zenfit/models/session_model.dart';
import 'package:zenfit/db/database_helper.dart';

class User {
  final int? id;
  final String email;
  final String password;
  final List<Session>? sessions;

  // Constructeur de la classe User
  User({
    this.id,
    required this.email,
    required this.password,
    this.sessions,
  });

  // Convertir l'objet User en Map pour SQLite
  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'password': password,
  };

  // Créer un objet User à partir d'un Map (JSON-like)
  static User fromJson(Map<String, dynamic> json, List<Session>? sessions) => User(
    id: json['id'] as int?,
    email: json['email'] as String,
    password: json['password'] as String,
    sessions: sessions,
  );
}
