import 'package:basso_hoogerheide/controllers/calendar.dart';
import 'package:basso_hoogerheide/extensions.dart';
import 'package:basso_hoogerheide/interface/notifications.dart';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/calendar_event.dart';
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

class _EventCardState extends ConsumerState<EventCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animationController;

  late CurvedAnimation _curvedAnimation;

  bool _expanded = false;

  TapDownDetails? _tapDetails;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuart,
    );
  }

  @override
  Widget build(BuildContext context) {
    final LocalNotification? notification =
        ref.watch(scheduledNotificationsProvider).value?[widget.event.id];
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          alignment: Alignment.topRight,
          clipBehavior: Clip.none,
          children: [
            Card(
              color: widget.event.color?.withOpacity(1) ??
                  Theme.of(context).colorScheme.primary,
              shape: _expanded
                  ? const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(4),
                        bottom: Radius.zero,
                      ),
                    )
                  : null,
              child: InkWell(
                onTap: _onTapCard,
                onTapDown: (details) => _tapDetails = details,
                onLongPress: _onLongPress,
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
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (!_expanded && notification != null)
              Positioned(
                top: -12,
                right: -12,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  width: 24,
                  height: 24,
                  child: Icon(
                    Icons.notifications_on,
                    size: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
          ],
        ),
        SizeTransition(
          sizeFactor: _curvedAnimation,
          child: Container(
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
                            valueString: widget.event.startTime.format(context),
                          ),
                          KeyValueText(
                            keyString: 'Término',
                            valueString: widget.event.endTime.format(context),
                          ),
                        ],
                      ),
                    ),
                    if (widget.event.startDateTime.isAfter(DateTime.now()))
                      GestureDetector(
                        onTap: () => _onTapNotification(notification != null),
                        child: Icon(
                          notification != null
                              ? Icons.notifications_active
                              : Icons.notifications_outlined,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
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
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onTapCard() async {
    if (_animationController.isAnimating) return;
    if (_expanded) {
      await _animationController.reverse();
    } else {
      await _animationController.forward();
    }
    setState(() => _expanded = !_expanded);
  }

  void _onLongPress() async {
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
            .read(calendarControllerProvider)
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

  void _onTapNotification(bool isEnabled) async {
    final Duration? duration = await showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Notificar...',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              ...[
                const Duration(minutes: 15),
                const Duration(minutes: 30),
                const Duration(hours: 1),
                const Duration(hours: 2),
                const Duration(hours: 4),
                const Duration(hours: 8),
                const Duration(hours: 16),
              ]
                  .where((e) => widget.event.startDateTime
                      .subtract(e)
                      .isAfter(DateTime.now()))
                  .map(
                    (e) => InkWell(
                      onTap: () => Navigator.pop(context, e),
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          '${e.string()} antes',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ),
              if (isEnabled)
                GestureDetector(
                  onTap: () => Navigator.pop(
                    context,
                    const Duration(minutes: -1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Remover notificação',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (duration == null) return;

    final CalendarEvent event = widget.event;
    final Notifications notifications = ref.read(notificationsProvider);

    if (duration.isNegative) {
      notifications.removeNotification(event.id);
      return;
    }

    notifications.scheduleNotification(
      LocalNotification(
        id: event.id,
        title: event.title,
        body: event.description,
      ),
      event.startDateTime.subtract(duration),
    );
  }
  
  @override
  bool get wantKeepAlive => _expanded;
}
