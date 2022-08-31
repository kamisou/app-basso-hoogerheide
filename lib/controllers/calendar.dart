import 'package:basso_hoogerheide/data_objects/output/new_calendar_event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final calendarControllerProvider = Provider((ref) => CalendarController());

class CalendarController {
  // TODO: adicionar evento
  Future<void> addEvent(NewCalendarEvent? event) async {}
}
