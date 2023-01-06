import 'package:basso_hoogerheide/models/input/calendar_event.dart';
import 'package:basso_hoogerheide/pages/home/calendar/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DayWidget extends ConsumerWidget {
  const DayWidget({
    super.key,
    required this.date,
    required this.today,
    this.events,
  });

  final DateTime date;

  final DateTime today;

  final List<CalendarEvent>? events;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Text(
                    DateFormat('E').format(date),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      color: today == date
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface,
                    ),
                    height: 48,
                    width: 48,
                    child: Text(
                      date.day.toString(),
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    DateFormat("'de 'MMMM' de 'yyyy").format(date),
                    style: today == date
                        ? Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            )
                        : Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (events != null)
            Column(
              children: events!
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: EventCard(event: e),
                      ))
                  .toList(),
            ),
        ],
      );
}
