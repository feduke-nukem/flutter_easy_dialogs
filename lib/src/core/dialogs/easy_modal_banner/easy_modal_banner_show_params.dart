import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/agents/full_screen_dialog_agent/full_screen_dialog_show_params.dart';

/// Show params for EasyModalBanner
class EasyModalBannerShowParams extends FullScreenShowParams {
  /// Decoration
  final BoxDecoration? decoration;

  /// Padding
  final EdgeInsets? padding;

  /// Margin
  final EdgeInsets? margin;

  /// Creates an instance of [EasyModalBannerShowParams]
  const EasyModalBannerShowParams({
    required super.theme,
    required super.content,
    required super.backgroundAnimationType,
    required super.contentAnimationType,
    super.onDismissed,
    this.padding,
    this.margin,
    this.decoration,
    super.backgroundColor,
    super.customBackgroundAnimation,
    super.customContentAnimation,
  });
}
