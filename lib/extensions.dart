import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  DateTime dayOnly() => DateTime(year, month, day);
}

extension TimeOfDayExtension on TimeOfDay {
  static TimeOfDay? parse(String? date) {
    if (date == null) return null;
    return TimeOfDay.fromDateTime(DateTime.parse(date));
  }

  String fmt([bool twentyFourHours = true]) {
    final int h = twentyFourHours ? hour : hour % 12;
    final String ampm = twentyFourHours ? '' : ' ${hour >= 12 ? 'PM' : 'AM'}';
    return '${h.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}$ampm';
  }

  bool isAfter(TimeOfDay other) =>
      (hour * 60 + minute) > (other.hour * 60 + other.minute);

  bool isBefore(TimeOfDay other) =>
      (hour * 60 + minute) < (other.hour * 60 + other.minute);
}
