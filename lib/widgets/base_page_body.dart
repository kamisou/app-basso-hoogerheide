import 'package:flutter/material.dart';

abstract class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  String get title;

  VoidCallback? get fabAction;
}
