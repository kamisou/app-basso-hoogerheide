import 'package:basso_hoogerheide/widgets/async_button/async_button.dart';
import 'package:flutter/material.dart';

export 'package:basso_hoogerheide/widgets/async_button/async_button.dart';

class TextAsyncButton extends AsyncButton {
  const TextAsyncButton({
    super.key,
    required super.onPressed,
    required super.child,
    required super.loadingChild,
    super.controller,
  });

  @override
  State<AsyncButton> createState() => _TextAsyncButtonState();
}

class _TextAsyncButtonState extends AsyncButtonState {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: ready ? onPressedCallback : null,
      child: ready ? widget.child : widget.loadingChild,
    );
  }
}
