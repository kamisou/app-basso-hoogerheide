import 'package:basso_hoogerheide/controllers/calendar.dart';
import 'package:basso_hoogerheide/data_objects/output/calendar_event.dart';
import 'package:basso_hoogerheide/pages/home/calendar/add_event_dialog.dart';
import 'package:basso_hoogerheide/pages/home/calendar/day.dart';
import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  final CalendarController controller = const CalendarController();

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit_calendar),
        onPressed: () => showDialog<CalendarEventOutput>(
          context: context,
          builder: (_) => const AddEventDialog(),
        ).then(controller.addEvent),
      ),
      body: InfiniteListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemBuilder: (_, index) => Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: DayWidget(
            date: (index > 0)
                ? today.add(Duration(days: index))
                : today.subtract(Duration(days: index)),
            today: today,
            // TODO: utilizar dados de eventos do calendário
            events: const [],
          ),
        ),
      ),
    );
  }
}
