import 'package:basso_hoogerheide/extensions.dart';
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

  void setStartTime(TimeOfDay? value) {
    startTime = value;
    if (startTime == null) {
      endTime = null;
    } else {
      if (endTime == null) {
        endTime = value;
      } else if (startTime!.isAfter(endTime!)) {
        endTime = startTime;
      }
    }
  }

  void setEndTime(TimeOfDay? value) {
    endTime = value;
    if (endTime == null) {
      startTime = null;
    } else {
      if (endTime!.isBefore(startTime!)) {
        startTime = endTime;
      }
    }
  }

  void setTitle(String? value) => title = value;

  void setDescription(String? value) => description = value;

  void setColor(Color? value) => color = value;

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date != null ? DateFormat('yyyy-MM-dd').format(date!) : null,
        'start_time': startTime?.fmt(),
        'end_time': endTime?.fmt(),
        'title': title,
        'description': description,
        'color': color!.value.toRadixString(16),
      };
}
