import 'package:flutter/material.dart';

abstract class BasePageBody extends StatelessWidget {
  const BasePageBody({
    super.key,
    required this.title,
    this.fabAction,
  });

  final String title;

  final VoidCallback? fabAction;
}
