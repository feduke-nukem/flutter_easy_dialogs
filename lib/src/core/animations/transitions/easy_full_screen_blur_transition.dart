import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/animations/widgets/easy_full_screen_blur.dart';

/// Full screen blur transition
class EasyFullScreenBlurTransition extends AnimatedWidget {
  /// Child
  final Widget child;

  /// Background color
  final Color? backgroundColor;

  /// Creates an instance of [EasyFullScreenBlurTransition]
  const EasyFullScreenBlurTransition({
    required Animation<double> blur,
    required this.child,
    this.backgroundColor,
    super.key,
  }) : super(listenable: blur);

  @override
  Widget build(BuildContext context) {
    final blur = listenable as Animation<double>;

    return EasyFullScreenBlur(
      opacity: 1,
      blur: blur.value,
      backgroundColor: backgroundColor,
      child: child,
    );
  }
}
