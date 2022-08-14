import 'package:basso_hoogerheide/data_objects/calendar/event.dart';
import 'package:basso_hoogerheide/pages/calendar/event_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayWidget extends StatelessWidget {
  const DayWidget({
    super.key,
    required this.date,
    required this.today,
    required this.events,
  });

  final DateTime date;

  final DateTime today;

  final List<Event> events;

  @override
  Widget build(BuildContext context) {
    final bool isToday = date.day == today.day;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Text(
                    DateFormat.E().format(date),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: isToday
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface,
                    ),
                    height: 48,
                    width: 48,
                    child: Text(
                      date.day.toString(),
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
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
                    style: isToday
                        ? Theme.of(context).textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                            )
                        : Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          ListView.separated(
            itemBuilder: (_, index) => EventCard(event: events[index]),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: events.length,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
          ),
        ],
      ),
    );
  }
}
