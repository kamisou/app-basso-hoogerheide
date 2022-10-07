import 'package:basso_hoogerheide/extensions.dart';
import 'package:flutter/material.dart';

class CalendarEvent {
  CalendarEvent.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        date = DateTime.parse(json['start']).dayOnly(),
        startTime = TimeOfDayExtension.parse(json['start'])!,
        endTime = TimeOfDayExtension.parse(json['end'])!,
        title = json['title'],
        description = json['description'] {
    final String? hexString = json['color'];
    if (hexString?.isEmpty ?? true) {
      color = null;
      return;
    }
    final int? hex = int.tryParse(hexString!.substring(1), radix: 16);
    color = hex != null ? Color((0xff << 24) | hex) : null;
  }

  final int id;

  final DateTime date;

  final TimeOfDay startTime;

  final TimeOfDay endTime;

  final String title;

  final String? description;

  late Color? color;
}
