import 'package:flutter/material.dart';
import 'package:zenfit/models/exercices_model.dart';
import 'package:zenfit/db/database_helper.dart';

class Session {
  final int? id;
  final String name;
  final String sessionType;
  final Duration duration;
  final List<Exercise> exercises;
  final DateTime date;
  final int reminder;
  final String? comment;

  Session({
    this.id,
    required this.name,
    required this.sessionType,
    required this.duration,
    required this.exercises,
    required this.date,
    required this.reminder,
    this.comment,
  });

  // Convertir l'objet Session en Map pour SQLite
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'sessionType': sessionType,
    'duration': duration.inMinutes, // Stocké en minutes
    'date': date.toIso8601String(), // Date en chaîne ISO 8601
    'reminder': reminder,
    'comment': comment,
  };

  // Créer un objet Session à partir d'un Map (JSON-like)
  static Session fromJson(Map<String, dynamic> json, List<Exercise> exercises) => Session(
    id: json['id'] as int?,
    name: json['name'] as String,
    sessionType: json['sessionType'] as String,
    duration: Duration(minutes: json['duration'] as int),
    exercises: exercises,
    date: DateTime.parse(json['date'] as String),
    reminder: json['reminder'] as int,
    comment: json['comment'] as String?,
  );
}