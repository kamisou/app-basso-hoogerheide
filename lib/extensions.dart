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

extension DurationExtension on Duration {
  String string() {
    if (inHours > 0) return '$inHours hora${inHours > 1 ? 's' : ''}';
    if (inMinutes > 0) return '$inMinutes minuto${inMinutes > 1 ? 's' : ''}';
    return '$inSeconds hora${inSeconds > 1 ? 's' : ''}';
  }
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
