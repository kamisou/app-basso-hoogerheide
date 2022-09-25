import 'package:flutter/material.dart';

class NewCalendarEvent {
  NewCalendarEvent.empty();

  DateTime? startDate;

  DateTime? endDate;

  String? title;

  String? description;

  Color? color;

  void setStartDate(DateTime? value) => startDate = value;

  void setEndDate(DateTime? value) => endDate = value;

  void setTitle(String? value) => title = value;

  void setDescription(String? value) => description = value;

  void setColor(Color? value) => color = value;

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'start_date': startDate?.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
        'color': color?.value,
      };
}
