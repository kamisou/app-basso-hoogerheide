import 'package:basso_hoogerheide/extensions.dart';
import 'package:flutter/material.dart';

class ProcessInfo {
  ProcessInfo.fromJson(Map<String, dynamic> json)
      : nature = json['nature'],
        color = ColorExtension.parseHex(json['color'])!,
        attorney = json['attorney'],
        number = json['number'],
        protocolDate = json['protocol_date'],
        county = json['county'],
        division = json['division'];

  final String nature;

  final Color color;

  final String attorney;

  final String? number;

  final String? protocolDate;

  final String? county;

  final String? division;
}
