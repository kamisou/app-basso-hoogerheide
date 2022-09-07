import 'dart:developer';

import 'package:basso_hoogerheide/extensions.dart';
import 'package:basso_hoogerheide/models/input/calendar_event.dart';
import 'package:basso_hoogerheide/models/output/new_calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef CalendarEvents = Map<DateTime, List<CalendarEvent>>;

final calendarRepositoryProvider =
    Provider.autoDispose((ref) => const CalendarRepository());

final initialCalendarEventsProvider = FutureProvider.autoDispose.family(
  (ref, DateTime initialDate) => ref.read(calendarRepositoryProvider).getEvents(
        initialDate.subtract(CalendarEventsRepository.prefetchDays),
        initialDate.add(CalendarEventsRepository.prefetchDays),
      ),
);

final calendarEventsRepositoryProvider = Provider.family(
  (ref, DateTime initialDate) {
    final initialData = ref.read(initialCalendarEventsProvider(initialDate));
    return CalendarEventsRepository(
      repository: ref.read(calendarRepositoryProvider),
      initialData: initialData.value!,
      initialDate: initialDate,
    );
  },
);

final calendarEventColorsProvider = Provider.autoDispose(
  (ref) => ref.read(calendarRepositoryProvider).getEventColors(),
);

class CalendarRepository {
  const CalendarRepository();

  // TODO: adicionar evento
  Future<void> addEvent(NewCalendarEvent? event) {
    log('addEvent');
    return Future.delayed(const Duration(seconds: 3));
  }

  // TODO: buscar eventos reais
  Future<CalendarEvents> getEvents(DateTime startDate, DateTime endDate) async {
    log('getEvents');
    return {};
  }

  // TODO: buscar cores reais
  Future<List<Color>> getEventColors() async {
    log('getEventColors');
    return [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.black,
      Colors.white,
    ];
  }
}

class CalendarEventsRepository {
  static const Duration prefetchDays = Duration(days: 180);
  static const int _prefetchTriggerDays = 60;

  CalendarEventsRepository({
    required CalendarRepository repository,
    required CalendarEvents initialData,
    required DateTime initialDate,
  })  : _events = initialData,
        _repository = repository,
        _startDate = initialDate.subtract(prefetchDays),
        _endDate = initialDate.add(prefetchDays);

  final CalendarRepository _repository;

  final CalendarEvents _events;

  late DateTime _startDate;

  late DateTime _endDate;

  List<CalendarEvent>? getDayEvents(DateTime date) {
    final DateTime day = date.dayOnly();
    if (day.difference(_startDate).inDays < _prefetchTriggerDays) {
      final DateTime newFirstDate = _startDate.subtract(prefetchDays);
      _repository
          .getEvents(newFirstDate, _startDate.subtract(const Duration(days: 1)))
          .then((value) => _events.addAll(value));
      _startDate = newFirstDate;
    } else if (day.difference(_endDate).inDays > -_prefetchTriggerDays) {
      final DateTime newEndDate = _endDate.add(prefetchDays);
      _repository
          .getEvents(_endDate.add(const Duration(days: 1)), newEndDate)
          .then((value) => _events.addAll(value));
      _endDate = newEndDate;
    }
    return _events[day];
  }
}
