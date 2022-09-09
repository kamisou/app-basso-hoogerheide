import 'dart:convert';

import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  DateTime dayOnly() => DateTime(year, month, day);
}

extension JsonCodecExtension on JsonCodec {
  List<Map<String, dynamic>> decodeList(String source) =>
      (decode(source) as List? ?? []).cast<Map<String, dynamic>>();

  Map<String, dynamic> decodeMap(String source) =>
      (decode(source) as Map<String, dynamic>);
}

extension TimeOfDayExtension on TimeOfDay {
  static TimeOfDay? parse(String? date) {
    final List<String>? start = date?.split(':');
    return start != null
        ? TimeOfDay(hour: int.parse(start.first), minute: int.parse(start.last))
        : null;
  }
}
