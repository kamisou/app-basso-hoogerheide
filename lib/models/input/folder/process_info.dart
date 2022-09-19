import 'package:basso_hoogerheide/models/input/app_user.dart';
import 'package:flutter/material.dart';

class ProcessInfo {
  ProcessInfo.fromJson(Map<String, dynamic> json)
      : nature = json['nature'],
        color = Color(int.parse(json['color'], radix: 16)),
        attorney = AppUser.fromJson(json['attorney']),
        number = json['number'],
        protocolDate = (json['protocol_date']?.isNotEmpty ?? false)
            ? DateTime.parse(json['protocol_date'])
            : null,
        district = json['district'],
        division = json['division'];

  final String nature;

  final Color color;

  final AppUser attorney;

  final int? number;

  final DateTime? protocolDate;

  final String? district;

  final String? division;
}
