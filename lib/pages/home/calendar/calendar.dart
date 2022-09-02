import 'package:basso_hoogerheide/extensions.dart';
import 'package:basso_hoogerheide/models/output/new_calendar_event.dart';
import 'package:basso_hoogerheide/models/repository/calendar.dart';
import 'package:basso_hoogerheide/pages/home/calendar/add_event_dialog.dart';
import 'package:basso_hoogerheide/pages/home/calendar/day.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_listview/infinite_listview.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime today = DateTime.now().dayOnly();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit_calendar),
        onPressed: () => showDialog<NewCalendarEvent>(
          context: context,
          builder: (_) => const AddEventDialog(),
        ).then(ref.read(calendarRepositoryProvider).addEvent),
      ),
      body: ref.watch(initialCalendarEventsProvider(today)).when(
            data: (data) => InfiniteListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (_, index) {
                final DateTime thisDate = today.add(Duration(days: index));
                return Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: DayWidget(
                    date: thisDate,
                    today: today,
                    events: ref
                        .read(calendarEventsRepositoryProvider(today))
                        .getDayEvents(thisDate),
                  ),
                );
              },
            ),
            error: (_, __) => const EmptyCard(
              icon: Icons.error,
              message: 'Não foi possível buscar os eventos do calendário',
            ),
            loading: () => Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.all(20),
              child: const CircularProgressIndicator(),
            ),
          ),
    );
  }
}
