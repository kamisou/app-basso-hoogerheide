import 'package:flutter/material.dart';

class Event {
  final TimeOfDay startTime;

  final TimeOfDay endTime;

  final String title;

  final String description;

  final Color color;

  const Event({
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.description,
    required this.color,
  });
}
