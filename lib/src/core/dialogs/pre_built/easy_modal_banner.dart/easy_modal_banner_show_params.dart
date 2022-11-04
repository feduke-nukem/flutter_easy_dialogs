import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/agents/fullscreen_dialog_agent/fullscreen_dialog_show_params.dart';

class EasyModalBannerShowParams extends FullScreenShowParams {
  final BoxDecoration? decoration;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  EasyModalBannerShowParams({
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
