import 'package:flutter/material.dart';

extension NavigatorExtension on Navigator {
  static Future<T?> pushReplacementNamedAndNotify<T extends Object?, TO extends Object?>(
    BuildContext context,
    String routeName,
    VoidCallback onAnimationFinished, {
    TO? result,
    Object? arguments,
  }) {
    final Animation? animation = ModalRoute.of(context)?.animation;
    void animationListener(AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        onAnimationFinished();
        animation!.removeStatusListener(animationListener);
      }
    }
    animation?.addStatusListener(animationListener);
    return Navigator.pushReplacementNamed(
      context,
      routeName,
      result: result,
      arguments: arguments,
    );
  }
}
