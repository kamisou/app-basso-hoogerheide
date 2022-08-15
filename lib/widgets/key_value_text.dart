import 'package:flutter/material.dart';

class KeyValueText extends StatelessWidget {
  const KeyValueText({
    super.key,
    required this.keyString,
    required this.valueString,
    this.style,
  });

  final String keyString;

  final String valueString;

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = style ?? Theme.of(context).textTheme.titleMedium!;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: valueString,
            style: textStyle,
          ),
        ],
        text: '$keyString: ',
        style: textStyle.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
