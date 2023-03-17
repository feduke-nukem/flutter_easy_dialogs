import 'package:flutter/material.dart';

/// Widget of full screen content appearance
class EasyModalBanner extends StatelessWidget {
  /// Presented content
  final Widget child;

  /// Padding
  final EdgeInsets padding;

  /// Margin
  final EdgeInsets margin;

  /// Decoration
  final BoxDecoration? boxDecoration;

  /// Creates an instance of [EasyModalBanner]
  const EasyModalBanner({
    required this.child,
    this.padding = const EdgeInsets.all(60.0),
    this.margin = const EdgeInsets.symmetric(horizontal: 15.0),
    this.boxDecoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: margin,
        decoration: boxDecoration,
        padding: padding,
        child: child,
      ),
    );
  }
}
