import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({
    super.key,
    this.initialTime,
    this.labelText,
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
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  final TextEditingController _controller = TextEditingController();

  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  final FocusNode _focusNode = FocusNode();

  bool _opened = false;

  @override
  void initState() {
    super.initState();
    _controller.text = _valueString(context, widget.initialTime) ?? '';
    _focusNode.addListener(() {
      if (!_opened) {
        _focusNode.unfocus();
        _showTimePicker();
        _opened = true;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(_showTimePicker);
  }

  void _showTimePicker() {
    showTimePicker(
      context: context,
      helpText: widget.labelText,
      initialTime: widget.initialTime ?? TimeOfDay.fromDateTime(DateTime.now()),
    ).then((value) {
      final FormFieldState? currentState = _key.currentState;
      widget.onChanged?.call(value);
      currentState?.didChange(value);
      _controller.text = _valueString(context, value) ?? '';
      _opened = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormField<TimeOfDay>(
      key: _key,
      validator: widget.validator,
      initialValue: widget.initialTime,
      builder: (state) => GestureDetector(
        onTap: widget.enabled ? _showTimePicker : null,
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.calendar_today_outlined,
              color: widget.enabled
                  ? Theme.of(context).inputDecorationTheme.prefixIconColor
                  : Theme.of(context).disabledColor,
            ),
            labelText: widget.labelText,
          ),
          enabled: false,
          validator: (_) => state.errorText,
          focusNode: _focusNode,
        ),
      ),
    );
  }

  String? _valueString(BuildContext context, TimeOfDay? value) => value != null
      ? '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}'
      : null;
}
