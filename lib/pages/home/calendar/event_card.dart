import 'package:basso_hoogerheide/models/input/calendar_event.dart';
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

  TapDownDetails? _tapDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          color: widget.event.color,
          shape: _expanded
              ? const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(4),
                    bottom: Radius.zero,
                  ),
                )
              : null,
          child: InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            onTapDown: (details) => _tapDetails = details,
            onLongPress: () {
              if (_tapDetails == null) return;
              final double dx = _tapDetails!.globalPosition.dx;
              final double dy = _tapDetails!.globalPosition.dy;
              showMenu<String?>(
                context: context,
                position: RelativeRect.fromLTRB(dx, dy, dx, dy),
                items: [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Editar evento'),
                  ),
                  PopupMenuItem(
                    textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                    value: 'delete',
                    child: const Text('Deletar evento'),
                  ),
                ],
              );
            },
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
                    widget.event.startTime?.format(context) ?? 'O dia todo',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
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
                      if (widget.event.startTime != null)
                        KeyValueText(
                          keyString: 'Horário de Início',
                          valueString: widget.event.startTime!.format(context),
                        ),
                      if (widget.event.endTime != null)
                        KeyValueText(
                          keyString: 'Horário de Fim',
                          valueString: widget.event.endTime!.format(context),
                        ),
                      widget.event.description != null
                          ? KeyValueText(
                              keyString: 'Descrição',
                              valueString: widget.event.description!,
                            )
                          : Text(
                              '(Nenhuma informação sobre o evento)',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                            )
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
