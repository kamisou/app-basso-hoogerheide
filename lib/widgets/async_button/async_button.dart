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

abstract class AsyncButtonState extends State<AsyncButton> {
  bool ready = true;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(onPressedCallback);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(onPressedCallback);
    super.dispose();
  }

  void onPressedCallback() {
    widget.onPressed().whenComplete(() => setState(() => ready = true));
    setState(() => ready = false);
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
