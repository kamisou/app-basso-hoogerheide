import 'package:basso_hoogerheide/data_objects/output/new_calendar_event.dart';
import 'package:basso_hoogerheide/widgets/color_picker.dart';
import 'package:basso_hoogerheide/widgets/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEventDialog extends ConsumerWidget {
  const AddEventDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newEvent = ref.read(newEventProvider.notifier);
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
                            onChanged: newEvent.setColor,
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
                      onChanged: newEvent.setTitle,
                      validator: newEvent.validateTitle,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TimePicker(
                          labelText: 'Início:',
                          onChanged: newEvent.setStartTime,
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
                          initialTime: ref.watch(newEventProvider).startTime,
                          enabled:
                              ref.watch(newEventProvider).startTime != null,
                          onChanged: newEvent.setEndTime,
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
                          onChanged: newEvent.setDescription,
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
                                  ref.watch(newEventProvider),
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
