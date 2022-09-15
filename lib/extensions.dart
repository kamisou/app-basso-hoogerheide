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
}
