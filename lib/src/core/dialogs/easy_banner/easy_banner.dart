import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

/// Dialog banner
class EasyBanner extends StatelessWidget {
  /// Background color
  ///
  /// Use [ThemeData.primaryColor] if null
  final Color? backgroundColor;

  /// Presented content
  final Widget child;

  /// Padding
  final EdgeInsets padding;

  /// Position
  final EasyDialogPosition position;

  /// Margin
  final EdgeInsets margin;

  /// Border radius
  final BorderRadius borderRadius;

  /// Creates an instance of [EasyBanner]
  const EasyBanner({
    required this.child,
    required this.position,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(10.0),
    this.margin = EdgeInsets.zero,
    this.borderRadius = BorderRadius.zero,
    super.key,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Color?>('backgroundColor', backgroundColor))
      ..add(DiagnosticsProperty<EasyDialogPosition>('position', position))
      ..add(DiagnosticsProperty<EdgeInsets>('padding', padding));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: ColoredBox(
          color: backgroundColor ?? Theme.of(context).primaryColor,
          child: SafeArea(
            top: position == EasyDialogPosition.top,
            bottom: position == EasyDialogPosition.bottom,
            child: Padding(
              padding: padding,
              child: SizedBox(
                width: double.infinity,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
