import 'package:basso_hoogerheide/data_objects/calendar/event.dart';
import 'package:flutter/material.dart';

class EventCard extends StatefulWidget {
  const EventCard({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  static const Curve _expandAnimationCurve = Curves.easeInOut;

  static const Duration _expandAnimationDuration = Duration(milliseconds: 200);

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
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
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: _expandAnimationDuration,
          reverseDuration: _expandAnimationDuration,
          switchInCurve: _expandAnimationCurve,
          switchOutCurve: _expandAnimationCurve,
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
                      _bodyTextBuilder(
                        context,
                        'Horário de Início: ',
                        widget.event.startTime.format(context),
                      ),
                      _bodyTextBuilder(
                        context,
                        'Horário de Fim: ',
                        widget.event.endTime.format(context),
                      ),
                      _bodyTextBuilder(
                        context,
                        'Descrição: ',
                        widget.event.description,
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

  Widget _bodyTextBuilder(BuildContext context, String text, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: value,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
        text: text,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
