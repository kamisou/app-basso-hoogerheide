import 'package:basso_hoogerheide/extensions.dart';
import 'package:flutter/material.dart';

class CalendarEvent {
  CalendarEvent.fromJson(Map<String, dynamic> json)
      : startTime = TimeOfDayExtension.parse(json['start_time']),
        endTime = TimeOfDayExtension.parse(json['end_time']),
        title = json['title'],
        description = json['description'],
        color = Color(int.parse(json['color'], radix: 16));

  final TimeOfDay? startTime;

  final TimeOfDay? endTime;

  final String title;

  final String? description;

  final Color color;
}
