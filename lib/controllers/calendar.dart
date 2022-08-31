import 'package:basso_hoogerheide/data_objects/output/new_calendar_event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final calendarControllerProvider =
    Provider.autoDispose((ref) => CalendarController());

class CalendarController {
  // TODO: adicionar evento
  Future<void> addEvent(NewCalendarEvent? event) async {}

  String? validateEventTitle(String? value) =>
      (value?.isEmpty ?? true) ? 'Insira um nome para o evento' : null;
}
