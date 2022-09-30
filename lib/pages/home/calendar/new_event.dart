import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/calendar_event.dart';
import 'package:basso_hoogerheide/models/output/new_calendar_event.dart';
import 'package:basso_hoogerheide/models/repository/calendar.dart';
import 'package:basso_hoogerheide/widgets/async_button.dart';
import 'package:basso_hoogerheide/widgets/color_picker.dart';
import 'package:basso_hoogerheide/widgets/date_picker.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:basso_hoogerheide/widgets/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewEventPage extends ConsumerStatefulWidget {
  const NewEventPage({super.key});

  @override
  ConsumerState<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends ConsumerState<NewEventPage> {
  late CalendarEvent? _argEvent;

  late NewCalendarEvent _event;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _argEvent = ModalRoute.of(context)!.settings.arguments as CalendarEvent?;
    _event = _argEvent == null
        ? NewCalendarEvent.empty()
        : NewCalendarEvent.fromCalendarEvent(_argEvent!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo evento'),
      ),
      body: ref.watch(calendarEventColorsProvider).when(
            data: (data) {
              final DateTime today = DateTime.now();
              _event.date ??= today;
              _event.color ??= data.first;
              return Form(
                child: Builder(
                  builder: (context) {
                    return ListView(
                      padding: const EdgeInsets.all(20),
                      shrinkWrap: true,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Cor:',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(width: 8),
                            ColorPicker(
                              colors: data,
                              dialogTitle: Text(
                                'Escolha uma cor:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              initialValue: _event.color,
                              onChanged: _event.setColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: '* Título',
                          ),
                          initialValue: _event.title,
                          onChanged: _event.setTitle,
                          validator: (value) => (value?.isEmpty ?? true)
                              ? 'Informe um título para o evento.'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        DatePicker(
                          labelText: '* Data',
                          firstDate: today.subtract(const Duration(days: 3650)),
                          lastDate: today.add(const Duration(days: 3650)),
                          initialDate: _event.date,
                          onChanged: _event.setDate,
                          validator: (value) => value == null
                              ? 'Informe uma data para o evento.'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 4,
                            bottom: 24,
                          ),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              labelText: 'Descrição',
                            ),
                            initialValue: _event.description,
                            maxLines: 4,
                            onChanged: _event.setDescription,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedAsyncButton(
                          onPressed: () => _onSave(context),
                          loadingChild: SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          child: const Text('Salvar'),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
            error: (_, __) => const EmptyCard(
              icon: Icons.error_outline,
              message: 'Não foi possível buscar dados para novo evento.',
            ),
            loading: () => Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.all(20),
              child: const CircularProgressIndicator(),
            ),
          ),
    );
  }

  Future<void> _onSave(BuildContext context) async {
    if (Form.of(context)!.validate()) {
      final CalendarRepository calendarRepository =
          ref.read(calendarRepositoryProvider);

      return (_argEvent == null
              ? calendarRepository.addEvent(_event)
              : calendarRepository.editEvent(_event))
          .then(
        (_) => Navigator.pop(context),
        onError: (e) => ErrorSnackbar(
          context: context,
          error: e,
        ).on<RestException>(
          content: (error) => ErrorContent(message: error.serverMessage),
        ),
      );
    }
  }
}
