import 'package:flutter/material.dart';

extension ColorExtension on Color {
  static Color? parseHex(String? hexString) {
    if (hexString?.isEmpty ?? true) {
      return null;
    }
    final int? hex = int.tryParse(hexString!.substring(1), radix: 16);
    return hex != null ? Color(hex) : null;
  }
}

extension DateTimeExtension on DateTime {
  DateTime dayOnly() => DateTime(year, month, day);
}

extension TimeOfDayExtension on TimeOfDay {
  static TimeOfDay? parse(String? date) {
    if (date == null) return null;
    return TimeOfDay.fromDateTime(DateTime.parse(date));
  }

  bool isAfter(TimeOfDay other) =>
      (hour * 60 + minute) > (other.hour * 60 + other.minute);

  bool isBefore(TimeOfDay other) =>
      (hour * 60 + minute) < (other.hour * 60 + other.minute);
}
