import 'package:flutter/material.dart';

class RadioGroup<T> extends StatefulWidget {
  const RadioGroup({
    super.key,
    required this.values,
    required this.labels,
    this.initialValue,
    this.onChanged,
    this.direction,
    this.style,
  });

  final List<T> values;

  final List<String> labels;

  final T? initialValue;

  final void Function(T)? onChanged;

  final Axis? direction;

  final TextStyle? style;

  @override
  State<RadioGroup> createState() => _RadioGroupState<T>();
}

class _RadioGroupState<T> extends State<RadioGroup> {
  T? _groupValue;

  @override
  void initState() {
    super.initState();
    _groupValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: widget.direction ?? Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          setState(() => _groupValue = widget.values[index]);
          widget.onChanged?.call(_groupValue);
        },
        child: Row(
          children: [
            Radio<T>(
              value: widget.values[index],
              groupValue: _groupValue,
              onChanged: (_) {},
            ),
            const SizedBox(width: 8),
            Text(widget.labels[index], style: widget.style),
          ],
        ),
      ),
    );
  }
}
