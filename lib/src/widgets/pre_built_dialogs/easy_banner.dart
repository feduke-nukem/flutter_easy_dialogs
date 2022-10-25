import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/widgets/easy_dialogs/easy_dialogs_theme.dart';

/// Dialog banner
class EasyBanner extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;

  /// Default is ```EdgeInsets.all(10.0)```
  final EdgeInsets? padding;

  final bool topSafeArea;
  final bool bottomSafeArea;

  const EasyBanner({
    required this.child,
    this.topSafeArea = true,
    this.bottomSafeArea = true,
    this.backgroundColor,
    this.padding,
    super.key,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Color?>('backgroundColor', backgroundColor))
      ..add(DiagnosticsProperty<bool>('topSafeArea', topSafeArea))
      ..add(DiagnosticsProperty<bool>('bottomSafeArea', bottomSafeArea))
      ..add(DiagnosticsProperty<EdgeInsets>('padding', padding));
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor ??
          EasyDialogsTheme.of(context).easyBannerTheme.backgroundColor,
      child: SafeArea(
        top: topSafeArea,
        bottom: bottomSafeArea,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(10.0),
          child: SizedBox(
            width: double.infinity,
            child: child,
          ),
        ),
      ),
    );
  }
}
