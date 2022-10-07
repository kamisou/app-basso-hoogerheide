import 'package:basso_hoogerheide/extensions.dart';
import 'package:flutter/material.dart';

class TimeIntervalPicker extends StatefulWidget {
  const TimeIntervalPicker({
    super.key,
    this.initialStartTime,
    this.initialEndTime,
    this.startTimeLabelText,
    this.endTimeLabelText,
    this.onStartTimeChanged,
    this.onEndTimeChanged,
    this.validator,
  });

  final TimeOfDay? initialStartTime;

  final TimeOfDay? initialEndTime;

  final String? startTimeLabelText;

  final String? endTimeLabelText;

  final void Function(TimeOfDay?)? onStartTimeChanged;

  final void Function(TimeOfDay?)? onEndTimeChanged;

  final String? Function(TimeOfDay?, TimeOfDay?)? validator;

  @override
  State<StatefulWidget> createState() => _TimeIntervalPickerState();
}

class _TimeIntervalPickerState extends State<TimeIntervalPicker> {
  final TextEditingController _startController = TextEditingController();

  final TextEditingController _endController = TextEditingController();

  TimeOfDay? _start;

  TimeOfDay? _end;

  @override
  void initState() {
    super.initState();
    _start = widget.initialStartTime;
    _end = widget.initialEndTime;
    _startController.text = _start?.fmt() ?? '';
    _endController.text = _end?.fmt() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: (_) => widget.validator?.call(_start, _end),
      builder: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: state.hasError
                ? BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  )
                : null,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime:
                            _start ?? TimeOfDay.fromDateTime(DateTime.now()),
                      );
                      if (time == null) return;
                      if (_end?.isBefore(time) ?? true) {
                        _setEndTime(time);
                      }
                      _setStartTime(time);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _startController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.schedule_outlined),
                          labelText: widget.startTimeLabelText,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  ' - ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: _end ??
                            TimeOfDay.fromDateTime(
                              DateTime.now().add(
                                const Duration(hours: 1),
                              ),
                            ),
                      );
                      if (time == null) return;
                      if (time.isBefore(_start!)) {
                        _setStartTime(time);
                      }
                      _setEndTime(time);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _endController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.schedule_outlined),
                          labelText: widget.endTimeLabelText,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Text(
                state.errorText!,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  void _setStartTime(TimeOfDay? time) {
    _start = time;
    _startController.text = _start?.fmt() ?? '';
    widget.onStartTimeChanged?.call(time);
  }

  void _setEndTime(TimeOfDay? time) {
    _end = time;
    _endController.text = _end?.fmt() ?? '';
    widget.onEndTimeChanged?.call(time);
  }
}
