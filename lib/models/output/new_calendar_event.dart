import 'package:flutter/material.dart';

class NewCalendarEvent {
  NewCalendarEvent.empty()
      : startTime = null,
        endTime = null,
        title = null,
        description = null,
        color = null;

  TimeOfDay? startTime;

  TimeOfDay? endTime;

  String? title;

  String? description;

  Color? color;

  void setStartTime(TimeOfDay? value) => startTime = value;

  void setEndTime(TimeOfDay? value) => endTime = value;

  void setTitle(String? value) => title = value;

  void setDescription(String? value) => description = value;

  void setColor(Color? value) => color = value;

  Map<String, dynamic> toJson() => {
        'start_time': '${startTime!.hour}${startTime!.minute}',
        'end_time': '${endTime!.hour}${endTime!.minute}',
        'title': title,
        'description': description,
        'color': color!.value,
      };
}
