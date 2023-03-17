import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/animations/easy_animation.dart';
import 'package:flutter_easy_dialogs/src/core/animations/types/easy_positioned_animation_type.dart';
import 'package:flutter_easy_dialogs/src/core/managers/positioned_dialog_manager/positioned_dialog_show_params.dart';

/// Show params for EasyBanner
class EasyBannerShowParams extends PositionedDialogShowParams {
  /// Padding
  final EdgeInsets? padding;

  /// Animation type
  final EasyPositionedAnimationType animationType;

  /// Custom animation
  final IEasyAnimator? customAnimation;

  /// Margin
  final EdgeInsets? margin;

  /// Border radius
  final double? borderRadius;

  final Color? backgroundColor;

  /// Creates an instance of [EasyBannerShowParams]
  const EasyBannerShowParams({
    required this.animationType,
    required super.position,
    required super.autoHide,
    required super.dismissibleType,
    required super.content,
    this.padding,
    this.customAnimation,
    this.borderRadius,
    this.margin,
    this.backgroundColor,
    super.onDismissed,
    super.durationUntilHide,
    super.animationSettings,
  });
}
