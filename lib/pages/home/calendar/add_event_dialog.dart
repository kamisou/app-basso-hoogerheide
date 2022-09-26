import 'package:basso_hoogerheide/models/output/new_calendar_event.dart';
import 'package:basso_hoogerheide/models/repository/calendar.dart';
import 'package:basso_hoogerheide/widgets/color_picker.dart';
import 'package:basso_hoogerheide/widgets/date_picker.dart';
import 'package:basso_hoogerheide/widgets/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEventDialog extends ConsumerStatefulWidget {
  const AddEventDialog({super.key});

  @override
  ConsumerState<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends ConsumerState<AddEventDialog> {
  late NewCalendarEvent _event;

  late List<Color> _colors;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    _colors = args['colors'];

    _event = args['event'] != null
        ? NewCalendarEvent.fromCalendarEvent(args['event'])
        : NewCalendarEvent.empty();

    _event.color ??= _colors.first;
  }

  @override
  Widget build(BuildContext context) {
    final DateTime today = ref.watch(initialDateRepositoryProvider);
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Builder(
            builder: (context) {
              return ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Novo Evento',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            'Cor:',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(width: 8),
                          ColorPicker(
                            colors: _colors,
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
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '* Título:',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    initialValue: _event.title,
                    onChanged: _event.setTitle,
                    validator: (value) => (value?.isEmpty ?? true)
                        ? 'Informe um título para o evento'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '* Data:',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  DatePicker(
                    firstDate: today.subtract(const Duration(days: 3650)),
                    lastDate: today.add(const Duration(days: 3650)),
                    initialDate: _event.date,
                    onChanged: _event.setDate,
                    validator: (value) =>
                        value == null ? 'Insira a data do evento.' : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '* Período:',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: TimePicker(
                          initialTime: _event.startTime,
                          onChanged: (value) =>
                              setState(() => _event.setStartTime(value)),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '-',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      Expanded(
                        child: TimePicker(
                          initialTime: _event.endTime,
                          enabled: _event.startTime != null,
                          onChanged: _event.setEndTime,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Descrição:',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 24),
                        child: TextFormField(
                          initialValue: _event.description,
                          maxLines: 4,
                          onChanged: _event.setDescription,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Cancelar',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              if (Form.of(context)!.validate()) {
                                Navigator.pop(context, _event);
                              }
                            },
                            child: Text(
                              'Salvar',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
