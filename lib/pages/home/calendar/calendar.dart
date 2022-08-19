import 'package:basso_hoogerheide/pages/home/calendar/day.dart';
import 'package:basso_hoogerheide/widgets/base_page_body.dart';
import 'package:basso_hoogerheide/widgets/color_picker.dart';
import 'package:basso_hoogerheide/widgets/date_picker.dart';
import 'package:basso_hoogerheide/widgets/default_dialog.dart';
import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';

class CalendarPage extends HomePageBody {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    return InfiniteListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: DayWidget(
          date: today.add(Duration(days: index)),
          today: today,
        ),
      ),
    );
  }

  @override
  // TODO: adicionar evento
  void Function(BuildContext)? get fabAction => (context) => showDialog(
        context: context,
        builder: (context) {
          return DefaultDialog(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Novo Evento',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Cor:',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(width: 8),
                        ColorPicker(
                          colors: const [
                            Colors.red,
                            Colors.green,
                            Colors.blue,
                            Colors.pink,
                            Colors.yellow,
                            Colors.cyan,
                            Colors.white,
                            Colors.black,
                          ],
                          dialogTitle: Text(
                            'Escolha uma cor:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          // TODO: mudar cor do evento
                          onChanged: (color) {},
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      child: DatePicker(labelText: 'Início:'),
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
                    const Expanded(
                      child: DatePicker(labelText: 'Fim:'),
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
                    const SizedBox(height: 4),
                    TextFormField(
                      maxLines: 4,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );

  @override
  String get title => 'Agenda';
}
