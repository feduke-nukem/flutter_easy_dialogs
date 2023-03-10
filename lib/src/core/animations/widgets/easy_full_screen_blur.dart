
import 'dart:ui';

import 'package:flutter/material.dart';

/// Full screen blur widget
class EasyFullScreenBlur extends StatelessWidget {
  /// Amount of blur applied to the background
  final double blur;

  /// Amount of opacity applied to the background
  final double opacity;

  /// Presented child below
  final Widget child;

  /// Background color
  final Color? backgroundColor;

  /// Creates an instance of [EasyFullScreenBlur]
  const EasyFullScreenBlur({
    required this.blur,
    required this.opacity,
    required this.child,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: opacity,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: blur,
              sigmaY: blur,
            ),
            child: ColoredBox(
              color: backgroundColor ?? Colors.grey.withOpacity(0.5),
              child: const SizedBox(
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
