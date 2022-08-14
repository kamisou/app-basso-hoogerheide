import 'package:flutter/material.dart';

abstract class HomePageBody extends StatelessWidget {
  const HomePageBody({
    super.key,
    required this.title,
    this.fabAction,
  });

  final String title;

  final VoidCallback? fabAction;
}
