import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/agents/fullscreen_dialog_agent/fullscreen_dialog_show_params.dart';

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
    required super.backgroungAnimationType,
    required super.contentAnimationType,
    super.onDismissed,
    this.padding,
    this.margin,
    this.decoration,
    super.backgroundColor,
    super.customBackgroungAnimation,
    super.customContentAnimation,
  });
}
