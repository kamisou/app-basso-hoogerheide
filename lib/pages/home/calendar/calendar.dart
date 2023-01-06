import 'package:basso_hoogerheide/extensions.dart';
import 'package:basso_hoogerheide/pages/home/calendar/day.dart';
import 'package:basso_hoogerheide/repositories/calendar.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_listview/infinite_listview.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage>
    with AutomaticKeepAliveClientMixin {
  final InfiniteScrollController _controller = InfiniteScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final DateTime today = DateTime.now().dayOnly();
    final DateTime initialDate = ref.watch(initialDateRepositoryProvider);

    return Scaffold(
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'calendar_today_fab',
            onPressed: _jumpToDateFabAction,
            child: const Icon(Icons.today_outlined),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'calendar_fab',
            child: const Icon(Icons.edit_calendar),
            onPressed: () => Navigator.pushNamed(context, '/newEvent'),
          ),
        ],
      ),
      body: ref.watch(initialCalendarEventsProvider).when(
            data: (data) {
              final CalendarEventsRepository calendarEvents =
                  ref.read(calendarEventsRepositoryProvider);
              return InfiniteListView.builder(
                controller: _controller,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (_, index) {
                  final DateTime thisDate =
                      initialDate.add(Duration(days: index));
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: DayWidget(
                      date: thisDate,
                      today: today,
                      events: calendarEvents.getDayEvents(thisDate),
                    ),
                  );
                },
              );
            },
            error: (_, __) => RefreshIndicator(
              onRefresh: () async => ref.refresh(initialCalendarEventsProvider),
              child: const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: EmptyCard(
                    icon: Icons.error,
                    message: 'Não foi possível buscar os eventos do calendário',
                  ),
                ),
              ),
            ),
            loading: () => Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.all(20),
              child: const CircularProgressIndicator(),
            ),
          ),
    );
  }

  Future<void> _jumpToDateFabAction() async {
    final DateTime now = DateTime.now();
    final DateTime? date = await showDatePicker(
      helpText: 'Ir para...',
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 3650)),
      lastDate: now.add(const Duration(days: 3650)),
    );
    if (date == null) return;
    final initialDate = ref.read(initialDateRepositoryProvider.notifier);
    if (initialDate.state != date) {
      initialDate.state = date;
      _controller.jumpTo(0);
      ref.invalidate(initialCalendarEventsProvider);
    } else {
      _controller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.decelerate,
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
