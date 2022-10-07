import 'package:basso_hoogerheide/constants/configuration.dart';
import 'package:basso_hoogerheide/interface/local_notifications.dart';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/calendar_event.dart';
import 'package:basso_hoogerheide/models/repository/calendar.dart';
import 'package:basso_hoogerheide/widgets/error_snackbar.dart';
import 'package:basso_hoogerheide/widgets/key_value_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventCard extends ConsumerStatefulWidget {
  const EventCard({
    super.key,
    required this.event,
  });

  final CalendarEvent event;

  @override
  ConsumerState<EventCard> createState() => _EventCardState();
}

class _EventCardState extends ConsumerState<EventCard> {
  bool _expanded = false;

  TapDownDetails? _tapDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          color: widget.event.color ?? Theme.of(context).colorScheme.primary,
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
            onLongPress: () => _onLongPress(context),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                KeyValueText(
                                  keyString: 'Início',
                                  valueString:
                                      widget.event.startTime.format(context),
                                ),
                                KeyValueText(
                                  keyString: 'Término',
                                  valueString:
                                      widget.event.endTime.format(context),
                                ),
                              ],
                            ),
                          ),
                          ref.watch(scheduledNotificationsProvider).when(
                                data: (data) {
                                  final LocalNotification? event = data[ref
                                          .read(configurationProvider)
                                          .calendarNotificationChannelKey]
                                      ?[widget.event.id];
                                  return GestureDetector(
                                    onTap: () =>
                                        _onTapNotification(event != null),
                                    child: Icon(
                                      event != null
                                          ? Icons.notifications_active
                                          : Icons.notifications_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  );
                                },
                                loading: () => Icon(
                                  Icons.notifications_outlined,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                error: (_, __) => const SizedBox.shrink(),
                              ),
                        ],
                      ),
                      widget.event.description?.isNotEmpty ?? false
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

  void _onLongPress(BuildContext context) async {
    if (_tapDetails == null) return;
    final double dx = _tapDetails!.globalPosition.dx;
    final double dy = _tapDetails!.globalPosition.dy;
    showMenu<String?>(
      context: context,
      position: RelativeRect.fromLTRB(dx, dy, dx, dy),
      items: [
        const PopupMenuItem(value: 'edit', child: Text('Editar evento')),
        PopupMenuItem(
          textStyle: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Theme.of(context).colorScheme.error),
          value: 'delete',
          child: const Text('Deletar evento'),
        ),
      ],
    ).then((value) {
      if (value == 'edit') {
        Navigator.pushNamed(context, '/newEvent', arguments: widget.event);
      } else if (value == 'delete') {
        ref
            .read(calendarRepositoryProvider)
            .deleteEvent(widget.event)
            .catchError(
              (e) => ErrorSnackbar(
                context: context,
                error: e,
              ).on<RestException>(
                content: (error) => ErrorContent(message: error.serverMessage),
              ),
            );
      }
    });
  }

  void _onTapNotification(bool isEnabled) {
    final notifications = ref.read(localNotificationsProvider);

    final CalendarEvent event = widget.event;

    if (isEnabled) {
      notifications.removeNotification(event.id);
    } else {
      notifications
          .addNotification(
        LocalNotification(
          id: event.id,
          channelKey:
              ref.read(configurationProvider).calendarNotificationChannelKey,
          title: event.title,
          body: event.description,
        ),
        event.date.add(
          Duration(
            hours: event.startTime.hour,
            minutes: event.startTime.minute,
          ),
        ),
      )
          .then((success) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Uma notificação foi adicionada para o evento.',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Icon(Icons.notifications_outlined),
                ],
              ),
            ),
          );
        }
      });
    }
  }
}
