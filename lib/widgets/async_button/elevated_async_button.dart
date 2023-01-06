import 'package:basso_hoogerheide/widgets/async_button/async_button.dart';
import 'package:flutter/material.dart';

export 'package:basso_hoogerheide/widgets/async_button/async_button.dart';

class ElevatedAsyncButton extends AsyncButton {
  const ElevatedAsyncButton({
    super.key,
    required super.onPressed,
    required super.child,
    required super.loadingChild,
    super.controller,
  });

  @override
  State<AsyncButton> createState() => _ElevatedAsyncButtonState();
}

class _ElevatedAsyncButtonState extends AsyncButtonState {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ready ? onPressedCallback : null,
      child: ready ? widget.child : widget.loadingChild,
    );
  }
}
