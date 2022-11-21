import 'package:basso_hoogerheide/extensions.dart';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

typedef CalendarEvents = Map<DateTime, List<CalendarEvent>>;

final calendarRepositoryProvider = Provider.autoDispose(CalendarRepository.new);

final initialDateRepositoryProvider =
    StateProvider.autoDispose((ref) => DateTime.now().dayOnly());

final initialCalendarEventsProvider = FutureProvider.autoDispose(
  (ref) {
    final initialDate = ref.read(initialDateRepositoryProvider);
    return ref.read(calendarRepositoryProvider).getEvents(
          initialDate.subtract(CalendarEventsRepository.prefetchDays),
          initialDate.add(CalendarEventsRepository.prefetchDays),
        );
  },
);

final calendarEventsRepositoryProvider = Provider.autoDispose(
  (ref) {
    final initialDate = ref.read(initialDateRepositoryProvider);
    final initialData = ref.watch(initialCalendarEventsProvider);
    return CalendarEventsRepository(
      repository: ref.read(calendarRepositoryProvider),
      initialData: initialData.value!,
      initialDate: initialDate,
    );
  },
);

final calendarEventColorsProvider = FutureProvider.autoDispose(
  (ref) => ref.read(calendarRepositoryProvider).getEventColors(),
);

class CalendarRepository {
  const CalendarRepository(this.ref);

  final Ref ref;

  Future<CalendarEvents> getEvents(DateTime startDate, DateTime endDate) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    return ref
        .read(restClientProvider)
        .get(
          '/events'
          '?start_date=${dateFormat.format(startDate)}'
          '&end_date=${dateFormat.format(endDate)}',
        )
        .then((value) => (value['events'] as Map? ?? {}).map(
              (key, value) => MapEntry(
                DateTime.parse(key).dayOnly(),
                (value as List? ?? [])
                    .cast<Map<String, dynamic>>()
                    .map(CalendarEvent.fromJson)
                    .toList(),
              ),
            ));
  }

  Future<List<Color>> getEventColors() => ref
      .read(restClientProvider)
      .get('/events/colors')
      .then((value) => (value['colors'] as List? ?? [])
          .cast<String>()
          .map((e) => ColorExtension.parseHex(e)!.withOpacity(1))
          .toList());
}

class CalendarEventsRepository {
  static const Duration prefetchDays = Duration(days: 90);
  static const int _prefetchTriggerDays = 45;

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
