import 'package:flutter/widgets.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

class FullScreenShowParams extends AgentShowParams {
  final IEasyAnimator? customContentAnimation;
  final IEasyAnimator? customBackgroungAnimation;

  final Color? backgroundColor;

  final EasyDismissCallback? onDismissed;

  final EasyFullScreenBackgroungAnimationType backgroungAnimationType;

  final EasyFullScreenContentAnimationType contentAnimationType;

  const FullScreenShowParams({
    required super.theme,
    required super.content,
    required this.backgroungAnimationType,
    required this.contentAnimationType,
    this.onDismissed,
    this.backgroundColor,
    this.customContentAnimation,
    this.customBackgroungAnimation,
  });
}
