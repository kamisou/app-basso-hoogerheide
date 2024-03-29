import 'package:flutter/material.dart';

abstract class AsyncButton extends StatefulWidget {
  const AsyncButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.loadingChild,
    this.controller,
  });

  final Future<void> Function() onPressed;

  final Widget child;

  final Widget loadingChild;

  final AsyncButtonController? controller;
}

abstract class _AsyncButtonState extends State<AsyncButton> {
  bool _ready = true;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onPressedCallback);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onPressedCallback);
    super.dispose();
  }

  void _onPressedCallback() {
    widget.onPressed().whenComplete(() => setState(() => _ready = true));
    setState(() => _ready = false);
  }
}

class AsyncButtonController implements Listenable {
  final List<VoidCallback> _callbacks = [];

  void press() {
    for (final callback in _callbacks) {
      callback.call();
    }
  }

  @override
  void addListener(VoidCallback listener) => _callbacks.add(listener);

  @override
  void removeListener(VoidCallback listener) => _callbacks.remove(listener);
}

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

class _ElevatedAsyncButtonState extends _AsyncButtonState {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _ready ? _onPressedCallback : null,
      child: _ready ? widget.child : widget.loadingChild,
    );
  }
}

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

class _TextAsyncButtonState extends _AsyncButtonState {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _ready ? _onPressedCallback : null,
      child: _ready ? widget.child : widget.loadingChild,
    );
  }
}
