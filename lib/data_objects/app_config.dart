import 'package:flutter/material.dart';

class AppConfig {
  const AppConfig({
    required this.newFormFieldData,
    required this.newEventColors,
    required this.annotationOptions,
  });

  final dynamic newFormFieldData;

  final List<Color> newEventColors;

  final List<String> annotationOptions;
}
