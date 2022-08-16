import 'package:basso_hoogerheide/data_objects/calendar/calendar_event.dart';
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
          date: DateTime.now().add(Duration(days: index)),
          today: today,
          events: [
            const CalendarEvent(
              startTime: TimeOfDay(hour: 8, minute: 0),
              endTime: TimeOfDay(hour: 8, minute: 50),
              title: 'Pagamento para João da Silva',
              description:
                  'Delenit est justo odio vero consetetur adipiscing amet sit dolore.',
              color: Color(0xFFA81818),
            ),
            if (index % 16 == 0)
              const CalendarEvent(
                startTime: TimeOfDay(hour: 9, minute: 0),
                endTime: TimeOfDay(hour: 15, minute: 00),
                title: 'Atendimento Maria Silva',
                description: 'Delenit est justo odio vero consetetur.',
                color: Color(0xFF1840A8),
              ),
          ],
        ),
      ),
    );
    // return ListView.builder(
    //   padding: const EdgeInsets.symmetric(horizontal: 20),
    //   itemBuilder: (_, index) => Padding(
    //     padding: const EdgeInsets.only(bottom: 32),
    //     child: DayWidget(
    //       date: DateTime(2022, 6, 25).add(Duration(days: index)),
    //       today: today,
    //       events: [
    //         const CalendarEvent(
    //           startTime: TimeOfDay(hour: 8, minute: 0),
    //           endTime: TimeOfDay(hour: 8, minute: 50),
    //           title: 'Pagamento para João da Silva',
    //           description:
    //               'Delenit est justo odio vero consetetur adipiscing amet sit dolore.',
    //           color: Color(0xFFA81818),
    //         ),
    //         if (index % 16 == 0)
    //           const CalendarEvent(
    //             startTime: TimeOfDay(hour: 9, minute: 0),
    //             endTime: TimeOfDay(hour: 15, minute: 00),
    //             title: 'Atendimento Maria Silva',
    //             description: 'Delenit est justo odio vero consetetur.',
    //             color: Color(0xFF1840A8),
    //           ),
    //       ],
    //     ),
    //   ),
    // );
  }

  @override
  // TODO: adicionar evento
  VoidCallback? get fabAction => () {};

  @override
  String get title => 'Agenda';
}
