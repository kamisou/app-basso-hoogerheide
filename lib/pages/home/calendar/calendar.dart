import 'package:basso_hoogerheide/pages/home/calendar/day.dart';
import 'package:basso_hoogerheide/widgets/base_page_body.dart';
import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';

class CalendarPage extends HomePageBody {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    return InfiniteListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: DayWidget(
          date: today.add(Duration(days: index)),
          today: today,
        ),
      ),
    );
  }

  @override
  // TODO: adicionar evento
  VoidCallback? get fabAction => () {};

  @override
  String get title => 'Agenda';
}
