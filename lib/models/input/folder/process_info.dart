import 'package:flutter/material.dart';

class ProcessInfo {
  ProcessInfo.fromJson(Map<String, dynamic> json)
      : nature = json['nature'],
        color = Color(int.parse(json['color'], radix: 16)),
        attorney = json['attorney'],
        number = json['number'],
        protocolDate = ((json['protocol_date'] as String?)?.isNotEmpty ?? false)
            ? DateTime.parse(json['protocol_date'])
            : null,
        district = json['district'],
        division = json['division'];

  final String nature;

  final Color color;

  final String attorney;

  final int? number;

  final DateTime? protocolDate;

  final String? district;

  final String? division;
}
