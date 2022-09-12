import 'package:basso_hoogerheide/models/input/app_user.dart';
import 'package:flutter/material.dart';

class ProcessInfo {
  const ProcessInfo({
    required this.nature,
    required this.color,
    required this.attorney,
    this.number,
    this.protocolDate,
    this.district,
    this.division,
  });

  ProcessInfo.fromJson(Map<String, dynamic> json)
      : nature = json['nature'],
        color = Color(int.parse(json['color'], radix: 16)),
        attorney = AppUser.fromJson(json['attorney']),
        number = json['number'],
        protocolDate = DateTime.parse(json['protocol_date']),
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
