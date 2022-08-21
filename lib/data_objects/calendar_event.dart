import 'package:flutter/material.dart';

class CalendarEvent {
  const CalendarEvent({
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.description,
    required this.color,
  });

  const CalendarEvent.empty()
      : startTime = const TimeOfDay(hour: 0, minute: 0),
        endTime = const TimeOfDay(hour: 23, minute: 59),
        title = '',
        description = '',
        color = Colors.transparent;

  final TimeOfDay startTime;

  final TimeOfDay endTime;

  final String title;

  final String description;

  final Color color;

  CalendarEvent copyWith({
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? title,
    String? description,
    Color? color,
  }) =>
      CalendarEvent(
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        title: title ?? this.title,
        description: description ?? this.description,
        color: color ?? this.color,
      );
}
