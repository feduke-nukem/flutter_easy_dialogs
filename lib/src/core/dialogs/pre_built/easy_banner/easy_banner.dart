import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

/// Dialog banner
class EasyBanner extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;

  /// Default is ```EdgeInsets.all(10.0)```
  final EdgeInsets? padding;

  final EasyDialogPosition position;

  final EdgeInsets? margin;

  final double? radius;

  const EasyBanner({
    required this.child,
    required this.position,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.radius,
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
    final theme = FlutterEasyDialogsTheme.of(context).easyBannerTheme;

    return Padding(
      padding: margin ?? theme.margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(theme.radius),
        child: ColoredBox(
          color: backgroundColor ??
              FlutterEasyDialogsTheme.of(context)
                  .easyBannerTheme
                  .backgroundColor,
          child: SafeArea(
            top: position == EasyDialogPosition.top,
            bottom: position == EasyDialogPosition.bottom,
            child: Padding(
              padding: padding ?? const EdgeInsets.all(10.0),
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
