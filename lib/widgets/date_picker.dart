import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({
    super.key,
    this.labelText,
  });

  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (labelText != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  labelText!,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.calendar_today_outlined),
              ),
              enabled: false,
            ),
          ],
        );
      },
    );
  }
}
