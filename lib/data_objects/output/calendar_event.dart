import 'package:flutter/material.dart';

class CalendarEventOutput {
  const CalendarEventOutput({
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.description,
    required this.color,
  });

  const CalendarEventOutput.empty()
      : startTime = null,
        endTime = null,
        title = null,
        description = null,
        color = null;

  final TimeOfDay? startTime;

  final TimeOfDay? endTime;

  final String? title;

  final String? description;

  final Color? color;

  CalendarEventOutput copyWith({
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? title,
    String? description,
    Color? color,
  }) =>
      CalendarEventOutput(
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        title: title ?? this.title,
        description: description ?? this.description,
        color: color ?? this.color,
      );
}
