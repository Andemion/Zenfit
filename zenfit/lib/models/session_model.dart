import 'package:flutter/material.dart';
import 'package:zenfit/models/exercices_model.dart';

class Session {
  final String name;
  final String sessionType;
  final Duration duration;
  final List<Exercise> exercises;
  final DateTime date;
  final int reminder;

  Session({
        required this.name,
        required this.sessionType,
        required this.duration,
        required this.exercises,
        required this.date,
        required this.reminder,
  });
}