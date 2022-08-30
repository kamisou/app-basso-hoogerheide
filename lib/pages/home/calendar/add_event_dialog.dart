import 'package:basso_hoogerheide/data_objects/calendar_event.dart';
import 'package:basso_hoogerheide/widgets/color_picker.dart';
import 'package:basso_hoogerheide/widgets/time_picker.dart';
import 'package:flutter/material.dart';

class AddEventDialog extends StatefulWidget {
  const AddEventDialog({super.key});

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  CalendarEvent _event = const CalendarEvent.empty();

  // TODO: utilizar dados de cores para evento
  final List<Color> _colors = const [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.pink,
    Colors.cyan,
    Colors.white,
    Colors.black,
  ];

  @override
  void initState() {
    super.initState();
    _event = _event.copyWith(color: _colors.first);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            colors: _colors,
                            initialValue: _event.color,
                            dialogTitle: Text(
                              'Escolha uma cor:',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            onChanged: (value) =>
                                _event = _event.copyWith(color: value),
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
                      onChanged: (value) =>
                          _event = _event.copyWith(title: value),
                      validator: (value) =>
                          value!.isEmpty ? 'Adicione um título' : null,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TimePicker(
                          labelText: 'Início:',
                          onChanged: (value) =>
                              _event = _event.copyWith(startTime: value),
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
                          initialTime: _event.startTime,
                          onChanged: (value) =>
                              _event = _event.copyWith(endTime: value),
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
                          onChanged: (value) =>
                              _event = _event.copyWith(description: value),
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
                                // TODO: adicionar evento
                                Navigator.pop(context);
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
