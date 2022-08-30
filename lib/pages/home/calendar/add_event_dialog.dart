import 'package:basso_hoogerheide/controllers/calendar.dart';
import 'package:basso_hoogerheide/data_objects/output/calendar_event.dart';
import 'package:basso_hoogerheide/widgets/color_picker.dart';
import 'package:basso_hoogerheide/widgets/time_picker.dart';
import 'package:flutter/material.dart';

class AddEventDialog extends StatefulWidget {
  const AddEventDialog({super.key});

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  CalendarEventOutput _eventOutput = const CalendarEventOutput.empty();

  final CalendarController _controller = const CalendarController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Builder(
            builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
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
                            // TODO: usar dados de cor
                            colors: const [],
                            dialogTitle: Text(
                              'Escolha uma cor:',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            onChanged: (color) =>
                                _eventOutput.copyWith(color: color),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 24),
                    child: TextFormField(
                      onChanged: (title) =>
                          _eventOutput = _eventOutput.copyWith(title: title),
                      validator: _controller.validateEventTitle,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TimePicker(
                          labelText: 'Início:',
                          onChanged: (startTime) => setState(
                            () => _eventOutput =
                                _eventOutput.copyWith(startTime: startTime),
                          ),
                        ),
                      ),
                      Container(
                        alignment: const Alignment(0, .75),
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '-',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      Expanded(
                        child: TimePicker(
                          labelText: 'Fim:',
                          initialTime: _eventOutput.startTime,
                          enabled: _eventOutput.startTime != null,
                          onChanged: (endTime) => _eventOutput =
                              _eventOutput.copyWith(endTime: endTime),
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
                          maxLines: 4,
                          onChanged: (description) => _eventOutput =
                              _eventOutput.copyWith(description: description),
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
                                Navigator.pop(context, _eventOutput);
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
