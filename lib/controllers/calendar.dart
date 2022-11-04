import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/calendar_event.dart';
import 'package:basso_hoogerheide/models/output/new_calendar_event.dart';
import 'package:basso_hoogerheide/repositories/calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final calendarControllerProvider = Provider.autoDispose(CalendarController.new);

class CalendarController {
  const CalendarController(this.ref);

  final Ref ref;

  Future<void> addEvent(NewCalendarEvent event) {
    return ref
        .read(restClientProvider)
        .post('/events/add', body: event.toJson())
        .then((_) {
      ref.read(initialDateRepositoryProvider.notifier).state = event.date!;
      return ref.refresh(initialCalendarEventsProvider);
    });
  }

  Future<void> editEvent(NewCalendarEvent? event) async {
    if (event == null) return;
    return ref
        .read(restClientProvider)
        .put('/events/edit', body: event.toJson())
        .then((_) {
      ref.read(initialDateRepositoryProvider.notifier).state = event.date!;
      return ref.refresh(initialCalendarEventsProvider);
    });
  }

  Future<void> deleteEvent(CalendarEvent event) => ref
          .read(restClientProvider)
          .delete('/events/delete', body: {'id': event.id}).then((_) {
        ref.read(initialDateRepositoryProvider.notifier).state = event.date;
        return ref.refresh(initialCalendarEventsProvider);
      });
}
