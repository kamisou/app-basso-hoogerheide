import 'package:basso_hoogerheide/data_objects/calendar_event.dart';
import 'package:basso_hoogerheide/widgets/color_picker.dart';
import 'package:basso_hoogerheide/widgets/time_picker.dart';
import 'package:flutter/material.dart';

class AddEventDialog extends StatefulWidget {
  const AddEventDialog({
    super.key,
    required this.eventColors,
  });

  final List<Color> eventColors;

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final TextEditingController _title = TextEditingController();

  final TextEditingController _description = TextEditingController();

  Color? _color;

  TimeOfDay? _start;

  TimeOfDay? _end;

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
                            colors: widget.eventColors,
                            dialogTitle: Text(
                              'Escolha uma cor:',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            onChanged: (value) => _color = value,
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
                      controller: _title,
                      validator: (value) =>
                          value!.isEmpty ? 'Adicione um título' : null,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TimePicker(
                          labelText: 'Início:',
                          onChanged: (value) => setState(() => _start = value),
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
                          initialTime: _start,
                          enabled: _start != null,
                          onChanged: (value) => _end = value,
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
                          controller: _description,
                          maxLines: 4,
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
                                Navigator.pop(
                                  context,
                                  CalendarEvent(
                                    startTime: _start,
                                    endTime: _end,
                                    title: _title.text,
                                    description: _description.text,
                                    color: _color!,
                                  ),
                                );
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
