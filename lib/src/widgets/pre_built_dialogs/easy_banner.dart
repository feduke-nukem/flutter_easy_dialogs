import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/widgets/easy_dialogs/easy_dialogs_theme.dart';
import 'package:flutter_easy_dialogs/src/widgets/pre_built_dialogs/easy_dialog.dart';

/// Dialog banner
class EasyBanner extends EasyDialogBase {
  final Color? backgroundColor;

  /// Default is ```EdgeInsets.all(10.0)```
  final EdgeInsets? padding;

  final bool topSafeArea;
  final bool bottomSafeArea;

  const EasyBanner({
    required super.animation,
    required super.child,
    this.topSafeArea = true,
    this.bottomSafeArea = true,
    this.backgroundColor,
    this.padding,
    super.onCotrollPanelCreated,
    super.key,
  });

  /// Creates instance of [EasyBanner]

  @override
  EasyDialogBaseState createState() => _DialogBannerState();
}

class _DialogBannerState extends EasyDialogBaseState<EasyBanner> {
  @override
  Widget buildDialog(Widget content) {
    return ColoredBox(
      color: widget.backgroundColor ??
          EasyDialogsTheme.of(context).easyBannerTheme.backgroundColor,
      child: SafeArea(
        top: widget.topSafeArea,
        bottom: widget.bottomSafeArea,
        child: Padding(
          padding: widget.padding ?? const EdgeInsets.all(10.0),
          child: SizedBox(
            width: double.infinity,
            child: content,
          ),
        ),
      ),
    );
  }
}
