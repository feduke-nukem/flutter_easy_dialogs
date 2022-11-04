import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

class EasyModalBanner extends StatelessWidget {
  final Widget child;

  /// Defaults to  ```EdgeInsets.all(60.0)```
  final EdgeInsets? padding;

  ///  Defaults to  ```EdgeInsets.all(20.0)```
  final EdgeInsets? margin;

  final BoxDecoration? boxDecoration;

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
        padding: theme.easyModalBannerTheme.margin,
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
