import 'package:basso_hoogerheide/models/output/new_calendar_event.dart';
import 'package:basso_hoogerheide/models/repository/calendar.dart';
import 'package:basso_hoogerheide/widgets/color_picker.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewEventPage extends ConsumerStatefulWidget {
  const NewEventPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewEventPageState();
}

class _NewEventPageState extends ConsumerState<NewEventPage> {
  final NewCalendarEvent _event = NewCalendarEvent.empty();

  @override
  void initState() {
    final DateTime now = DateTime.now();
    _event.startDate = now;
    _event.endDate = now;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo evento')),
      body: ref.watch(calendarEventColorsProvider).when(
            data: (data) {
              _event.setColor(data.first);
              return ListView(
                padding: const EdgeInsets.all(32),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Cor:',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      ColorPicker(
                        colors: data,
                        dialogTitle: const Text('Selecione uma cor:'),
                        onChanged: _event.setColor,
                        initialValue: _event.color,
                      ),
                    ],
                  ),
                  Expanded(
                    child: _field(
                      context: context,
                      title: 'Título:',
                      field: TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.title_outlined),
                        ),
                        onChanged: _event.setTitle,
                        validator: (value) => (value?.isEmpty ?? true)
                            ? 'Informe um título para o evento.'
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _field(
                    context: context,
                    title: 'Data de Início:',
                    field: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: TextFormField(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _field(
                    context: context,
                    title: 'Data de Fim:',
                    field: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: TextFormField(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _field(
                    context: context,
                    title: 'Descrição:',
                    field: TextFormField(
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, _event),
                    child: const Text('Salvar'),
                  ),
                ],
              );
            },
            error: (_, __) => const EmptyCard(
              icon: Icons.info_outline,
              message: 'Falha ao buscar opções para o novo evento.',
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }

  Widget _field({
    required BuildContext context,
    required String title,
    required Widget field,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 4),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        field,
      ],
    );
  }
}
