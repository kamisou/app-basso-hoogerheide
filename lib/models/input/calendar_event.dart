import 'package:basso_hoogerheide/extensions.dart';
import 'package:flutter/material.dart';

class CalendarEvent {
  CalendarEvent.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        date = DateTime.parse(json['start']).dayOnly(),
        startTime = TimeOfDayExtension.parse(json['start'])!,
        endTime = TimeOfDayExtension.parse(json['end'])!,
        title = json['title'],
        description = json['description'],
        color = ColorExtension.parseHex(json['color']);

  final int id;

  final DateTime date;

  final TimeOfDay startTime;

  final TimeOfDay endTime;

  final String title;

  final String? description;

  final Color? color;

  DateTime get startDateTime =>
      date.add(Duration(hours: startTime.hour, minutes: startTime.minute));
}
