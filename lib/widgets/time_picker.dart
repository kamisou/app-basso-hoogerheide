import 'package:flutter/material.dart';

class TimePicker extends StatelessWidget {
  const TimePicker({
    super.key,
    this.labelText,
    this.initialTime,
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  final String? labelText;

  final TimeOfDay? initialTime;

  final void Function(TimeOfDay?)? onChanged;

  final String? Function(TimeOfDay?)? validator;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return FormField<TimeOfDay>(
      validator: validator,
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
            GestureDetector(
              onTap: (enabled)
                  ? () {
                      showTimePicker(
                        context: context,
                        initialTime:
                            initialTime ?? const TimeOfDay(hour: 0, minute: 0),
                      ).then((value) {
                        onChanged?.call(value);
                        state.didChange(value);
                      });
                    }
                  : null,
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.calendar_today_outlined,
                    color: enabled ? null : Theme.of(context).disabledColor,
                  ),
                  hintText: state.value?.format(context),
                ),
                enabled: false,
              ),
            ),
            if (state.errorText != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  state.errorText!,
                  style: Theme.of(context).inputDecorationTheme.errorStyle,
                ),
              ),
          ],
        );
      },
    );
  }
}
