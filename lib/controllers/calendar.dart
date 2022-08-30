import 'package:basso_hoogerheide/data_objects/output/calendar_event.dart';

class CalendarController {
  const CalendarController();

  Future<void> addEvent(CalendarEventOutput? event) async {
    if (event == null) return;
  }

  String? validateEventTitle(String? title) {
    if (title?.isEmpty ?? true) {
      return 'Adicione um título';
    }
    return null;
  }
}
