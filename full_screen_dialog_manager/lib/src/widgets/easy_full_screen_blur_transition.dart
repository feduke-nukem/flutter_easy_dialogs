import 'package:flutter/material.dart';
import 'package:full_screen_dialog_manager/src/widgets/easy_full_screen_blur.dart';

/// Full screen blur transition.
class EasyFullScreenBlurTransition extends AnimatedWidget {
  /// Child.
  final Widget child;

  /// Background color.
  final Color? backgroundColor;

  /// Creates an instance of [EasyFullScreenBlurTransition].
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
      blur: blur.value,
      opacity: 1,
      backgroundColor: backgroundColor,
      child: child,
    );
  }
}
