import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/animations/widgets/fullscreen_blur.dart';

/// Fullscreen blut transition
class FullScreenBlurTransition extends AnimatedWidget {
  /// Child
  final Widget child;

  /// Backgroung color
  final Color? backgorundColor;

  /// Creates an instance of [FullScreenBlurTransition]
  const FullScreenBlurTransition({
    required Animation<double> blur,
    required this.child,
    this.backgorundColor,
    super.key,
  }) : super(listenable: blur);

  @override
  Widget build(BuildContext context) {
    final blur = listenable as Animation<double>;

    return FullScreenBlur(
      opacity: 1,
      blur: blur.value,
      backgorundColor: backgorundColor,
      child: child,
    );
  }
}
