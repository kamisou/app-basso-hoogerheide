import 'package:basso_hoogerheide/widgets/default_dialog.dart';
import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => DefaultDialog(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                dialogTitle,
                const SizedBox(height: 16),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  shrinkWrap: true,
                  itemCount: colors.length,
                  itemBuilder: (context, index) {
                    final Color color = colors[index];
                    return GestureDetector(
                      onTap: () => Navigator.pop(context, color),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: color,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ).then((color) => onChanged?.call(color));
      },
      child: Container(
        decoration: BoxDecoration(
          border: initialValue == null
              ? Border.all(color: Theme.of(context).disabledColor)
              : null,
          borderRadius: BorderRadius.circular(16),
          color: initialValue,
        ),
        height: 32,
        width: 32,
      ),
    );
  }
}
