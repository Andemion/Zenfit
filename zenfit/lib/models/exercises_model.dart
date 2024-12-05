import 'package:flutter/material.dart';
import 'package:zenfit/db/database_helper.dart';

class Exercise {
  int? id;
  final String name;
  final int number;
  final Duration duration;

  Exercise({
    this.id,
    required this.name,
    required this.number,
    required this.duration
  });

  // Convertir un Exercise en Map pour SQLite
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'number': number,
    'duration': duration.inSeconds, // Stocké en secondes
  };

  // Créer un Exercise à partir d'un Map
  static Exercise fromJson(Map<String, dynamic> json) => Exercise(
    id: json['id'] as int?,
    name: json['name'] as String,
    number: json['number'] as int,
    duration: Duration(seconds: json['duration'] as int),
  );
}