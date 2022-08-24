import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({
    super.key,
    required this.firstDate,
    required this.lastDate,
    this.focusNode,
    this.initialDate,
    this.labelText,
    this.onChanged,
    this.validator,
    this.dateFormat = 'dd/MM/yyyy',
  });

  final String? labelText;

  final DateTime firstDate;

  final DateTime lastDate;

  final FocusNode? focusNode;

  final DateTime? initialDate;

  final void Function(DateTime?)? onChanged;

  final String? Function(DateTime?)? validator;

  final String dateFormat;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = _valueString(context, widget.initialDate) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      validator: widget.validator,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                showDatePicker(
                  context: context,
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate,
                  initialDate: widget.initialDate ?? DateTime.now(),
                ).then((value) {
                  widget.onChanged?.call(value);
                  state.didChange(value);
                  _controller.text = _valueString(context, value) ?? '';
                });
              },
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                  labelText: widget.labelText,
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

  String? _valueString(BuildContext context, DateTime? value) =>
      value != null ? DateFormat(widget.dateFormat).format(value) : null;
}
