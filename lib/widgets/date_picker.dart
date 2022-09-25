import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({
    super.key,
    required this.firstDate,
    required this.lastDate,
    this.initialDate,
    this.labelText,
    this.onChanged,
    this.validator,
    this.dateFormat = 'dd/MM/yyyy',
  });

  final String? labelText;

  final DateTime firstDate;

  final DateTime lastDate;

  final DateTime? initialDate;

  final void Function(DateTime?)? onChanged;

  final String? Function(DateTime?)? validator;

  final String dateFormat;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final TextEditingController _controller = TextEditingController();

  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  final FocusNode _focusNode = FocusNode();

  bool _opened = false;

  @override
  void initState() {
    super.initState();
    _controller.text = _valueString(context, widget.initialDate) ?? '';
    _focusNode.addListener(() {
      if (!_opened) {
        _focusNode.unfocus();
        _showDatePicker();
        _opened = true;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(_showDatePicker);
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      firstDate: widget.firstDate,
      helpText: widget.labelText,
      lastDate: widget.lastDate,
      initialDate: widget.initialDate ?? DateTime.now(),
    ).then((value) {
      if (value == null) return;
      final FormFieldState? currentState = _key.currentState;
      widget.onChanged?.call(value);
      currentState?.didChange(value);
      _controller.text = _valueString(context, value) ?? '';
      _opened = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      key: _key,
      initialValue: widget.initialDate,
      validator: widget.validator,
      builder: (state) {
        return GestureDetector(
          onTap: _showDatePicker,
          child: TextFormField(
            validator: (_) => state.errorText,
            controller: _controller,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.calendar_today_outlined),
              labelText: widget.labelText,
            ),
            focusNode: _focusNode,
          ),
        );
      },
    );
  }

  String? _valueString(BuildContext context, DateTime? value) =>
      value != null ? DateFormat(widget.dateFormat).format(value) : null;
}
