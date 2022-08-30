import 'package:flutter/material.dart';

class CalendarEvent {
  const CalendarEvent({
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.description,
    required this.color,
  });

  final TimeOfDay? startTime;

  final TimeOfDay? endTime;

  final String title;

  final String description;

  final Color color;
}
