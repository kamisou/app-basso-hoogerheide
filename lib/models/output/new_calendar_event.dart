import 'package:basso_hoogerheide/models/input/calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewCalendarEvent {
  NewCalendarEvent.empty() : id = null;

  NewCalendarEvent.fromCalendarEvent(CalendarEvent event)
      : id = event.id,
        date = event.date,
        startTime = event.startTime,
        endTime = event.endTime,
        title = event.title,
        description = event.description,
        color = event.color;

  final int? id;

  DateTime? date;

  TimeOfDay? startTime;

  TimeOfDay? endTime;

  String? title;

  String? description;

  Color? color;

  void setDate(DateTime? value) => date = value;

  void setStartTime(TimeOfDay? value) => startTime = value;

  void setEndTime(TimeOfDay? value) => endTime = value;

  void setTitle(String? value) => title = value;

  void setDescription(String? value) => description = value;

  void setColor(Color? value) => color = value;

  Map<String, dynamic> toJson() => {
        'id': id,
        'start': DateFormat('yyyy-MM-dd HH:mm:ss').format(
          date!.add(
            Duration(
              hours: startTime!.hour,
              minutes: startTime!.minute,
            ),
          ),
        ),
        'end': DateFormat('yyyy-MM-dd HH:mm:ss').format(
          date!.add(
            Duration(
              hours: endTime!.hour,
              minutes: endTime!.minute,
            ),
          ),
        ),
        'title': title,
        'description': description,
        'color': color!.value.toRadixString(16),
      };
}
