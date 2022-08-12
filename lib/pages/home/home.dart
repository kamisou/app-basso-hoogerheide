import 'package:basso_hoogerheide/data_objects/calendar/event.dart';
import 'package:basso_hoogerheide/pages/home/day.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                height: 40,
                margin: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 32,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: Material(
                        color: Theme.of(context).colorScheme.surface,
                        type: MaterialType.circle,
                        child: InkWell(
                          // TODO: go to profile
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {},
                          child: Center(
                            child: Text(
                              'JM',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox(width: 40)),
                    GestureDetector(
                      // TODO: leave app
                      onTap: () {},
                      child: const Icon(Icons.exit_to_app),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (_, index) => DayWidget(
                    date: DateTime(2022, 6, 25).add(Duration(days: index)),
                    events: const [
                      Event(
                        startTime: TimeOfDay(hour: 8, minute: 0),
                        endTime: TimeOfDay(hour: 8, minute: 50),
                        title: 'Pagamento para João da Silva',
                        description: 'Delenit est justo odio vero consetetur adipiscing amet sit dolore.',
                        color: Color(0xFFA81818),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          // TODO: add event
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
