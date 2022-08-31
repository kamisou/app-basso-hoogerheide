import 'package:basso_hoogerheide/data_objects/input/calendar_event.dart';
import 'package:basso_hoogerheide/data_objects/output/new_calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final calendarRepositoryProvider =
    Provider.autoDispose((ref) => const CalendarRepository());

final calendarEventsProvider = FutureProvider.autoDispose(
    (ref) => ref.read(calendarRepositoryProvider).getEvents());

class CalendarRepository {
  const CalendarRepository();

  // TODO: adicionar evento
  Future<void> addEvent(NewCalendarEvent event) =>
      Future.delayed(const Duration(seconds: 3));

  // TODO: buscar eventos reais
  Future<Map<DateTime, List<CalendarEvent>>> getEvents() => Future.delayed(
        const Duration(seconds: 2),
        () => {
          DateTime(2022, 09, 04): [
            const CalendarEvent(
              startTime: null,
              endTime: null,
              title: 'Evento 1',
              description: 'Descrição do evento',
              color: Colors.blueAccent,
            ),
          ],
          DateTime(2022, 09, 10): [
            const CalendarEvent(
              startTime: TimeOfDay(hour: 12, minute: 0),
              endTime: TimeOfDay(hour: 23, minute: 25),
              title: 'Evento 2',
              description: 'Descrição do evento',
              color: Colors.deepOrange,
            ),
          ],
        },
      );
}
