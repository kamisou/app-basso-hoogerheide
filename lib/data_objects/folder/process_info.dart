import 'package:basso_hoogerheide/data_objects/app_user.dart';
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

  final String nature;

  final Color color;

  final AppUser attorney;

  final int? number;

  final DateTime? protocolDate;

  final String? district;

  final String? division;
}
