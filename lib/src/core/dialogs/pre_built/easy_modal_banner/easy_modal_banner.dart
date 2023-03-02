import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

/// Widget of fullscreen content appearence
class EasyModalBanner extends StatelessWidget {
  /// Presented content
  final Widget child;

  /// Padding
  ///
  /// Depends on [FlutterEasyDialogsTheme] if is null
  final EdgeInsets? padding;

  /// Margin
  ///
  /// Depends on [FlutterEasyDialogsTheme] if is null
  final EdgeInsets? margin;

  /// Decoration
  ///
  /// Depends on [FlutterEasyDialogsTheme] if is null
  final BoxDecoration? boxDecoration;

  /// Creates an instance of [EasyModalBanner]
  const EasyModalBanner({
    required this.child,
    this.padding,
    this.margin,
    this.boxDecoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterEasyDialogsTheme.of(context);

    return Center(
      child: Padding(
        padding: margin ?? theme.easyModalBannerTheme.margin,
        child: DecoratedBox(
          decoration: boxDecoration?.copyWith(
                color: boxDecoration?.color?.withOpacity(0.3),
              ) ??
              theme.easyModalBannerTheme.decoration,
          child: Padding(
            padding: padding ?? theme.easyModalBannerTheme.padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
