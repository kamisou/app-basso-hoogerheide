import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  DateTime dayOnly() => DateTime(year, month, day);
}

extension TimeOfDayExtension on TimeOfDay {
  static TimeOfDay? parse(String? date) {
    final List<String>? start = date?.split(':');
    return start != null
        ? TimeOfDay(hour: int.parse(start.first), minute: int.parse(start.last))
        : null;
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
