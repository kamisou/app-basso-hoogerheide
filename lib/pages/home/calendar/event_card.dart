import 'package:basso_hoogerheide/constants/theme_data.dart';
import 'package:basso_hoogerheide/data_objects/calendar/calendar_event.dart';
import 'package:basso_hoogerheide/widgets/key_value_text.dart';
import 'package:flutter/material.dart';

class EventCard extends StatefulWidget {
  const EventCard({
    super.key,
    required this.event,
  });

  final CalendarEvent event;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final curveAndDuration =
        Theme.of(context).extension<CurveAndDurationExtension>()!;
    return Column(
      children: [
        Card(
          color: widget.event.color,
          shape: _expanded
              ? const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.zero,
                  ),
                )
              : null,
          child: InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.event.title,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  Text(
                    widget.event.startTime.format(context),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: curveAndDuration.duration,
          reverseDuration: curveAndDuration.duration,
          switchInCurve: curveAndDuration.curve,
          switchOutCurve: curveAndDuration.curve,
          child: _expanded
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      KeyValueText(
                        keyString: 'Horário de Início',
                        valueString: widget.event.startTime.format(context),
                      ),
                      KeyValueText(
                        keyString: 'Horário de Fim',
                        valueString: widget.event.endTime.format(context),
                      ),
                      KeyValueText(
                        keyString: 'Descrição',
                        valueString: widget.event.description,
                      ),
                    ],
                  ),
                )
              : const SizedBox(
                  height: 0,
                  width: double.infinity,
                ),
        ),
      ],
    );
  }
}
