import 'package:basso_hoogerheide/extensions.dart';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/output/new_calendar_event.dart';
import 'package:basso_hoogerheide/models/repository/calendar.dart';
import 'package:basso_hoogerheide/pages/home/calendar/add_event_dialog.dart';
import 'package:basso_hoogerheide/pages/home/calendar/day.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:basso_hoogerheide/widgets/error_snackbar.dart';
import 'package:basso_hoogerheide/widgets/loading_snackbar.dart';
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
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final DateTime initialDate = ref.watch(initialDateRepositoryProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'calendar_fab',
        child: const Icon(Icons.edit_calendar),
        onPressed: () => ref.read(calendarEventColorsProvider.future).then(
              (value) => showDialog<NewCalendarEvent>(
                context: context,
                builder: (_) => const AddEventDialog(),
                routeSettings: RouteSettings(arguments: {'colors': value}),
              ).then(ref.read(calendarRepositoryProvider).addEvent),
              onError: (e) => ErrorSnackbar(
                context: context,
                error: e,
              ).on<RestException>(
                content: (error) => ErrorContent(message: error.serverMessage),
              ),
            ),
      ),
      body: ref.watch(initialCalendarEventsProvider).when(
            data: (data) {
              final DateTime today = DateTime.now().dayOnly();
              final CalendarEventsRepository calendarEvents =
                  ref.read(calendarEventsRepositoryProvider);
              return InfiniteListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (_, index) {
                  final DateTime thisDate =
                      initialDate.add(Duration(days: index));
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 32),
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

  @override
  bool get wantKeepAlive => true;
}
