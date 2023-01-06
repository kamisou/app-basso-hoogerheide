import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  ColorPicker({
    super.key,
    required this.colors,
    required this.dialogTitle,
    this.initialValue,
    this.onChanged,
  }) : assert(colors.isNotEmpty, "'colors' cannot be empty!");

  final List<Color> colors;

  final Widget dialogTitle;

  final Color? initialValue;

  final void Function(Color?)? onChanged;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color _color;

  @override
  void initState() {
    super.initState();
    _color = widget.colors.contains(widget.initialValue)
        ? widget.initialValue!
        : widget.colors.first;
    widget.onChanged?.call(_color);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTapColorPicker,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
          color: _color.withOpacity(1),
        ),
        height: 32,
        width: 32,
      ),
    );
  }

  void _onTapColorPicker() async {
    final Color? color = await showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.dialogTitle,
              const SizedBox(height: 16),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                shrinkWrap: true,
                itemCount: widget.colors.length,
                itemBuilder: (context, index) {
                  final Color color = widget.colors[index];
                  return GestureDetector(
                    onTap: () => Navigator.pop(context, color),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                        color: color.withOpacity(1),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    if (color != null) {
      widget.onChanged?.call(color);
      setState(() => _color = color);
    }
  }
}
