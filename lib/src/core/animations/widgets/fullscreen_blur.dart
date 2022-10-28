import 'dart:ui';

import 'package:flutter/material.dart';

class FullScreenBlur extends StatelessWidget {
  final double blur;
  final double opacity;
  final Widget child;
  final Color? backgorundColor;

  const FullScreenBlur({
    required this.blur,
    required this.opacity,
    required this.child,
    this.backgorundColor,
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
              color: (backgorundColor ?? Colors.grey).withOpacity(0.5),
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
