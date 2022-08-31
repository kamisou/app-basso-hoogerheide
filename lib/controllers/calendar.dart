import 'package:basso_hoogerheide/data_objects/output/new_calendar_event.dart';
import 'package:basso_hoogerheide/repository/calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final calendarControllerProvider = Provider.autoDispose(CalendarController.new);

class CalendarController {
  const CalendarController(this.ref);

  final Ref ref;

  Future<void> addEvent(NewCalendarEvent? event) async {
    if (event == null) return;
    return ref.read(calendarRepositoryProvider).addEvent(event);
  }

  String? validateEventTitle(String? value) =>
      (value?.isEmpty ?? true) ? 'Insira um nome para o evento' : null;
}
