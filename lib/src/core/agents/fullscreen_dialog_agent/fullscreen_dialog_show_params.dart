import 'package:flutter/widgets.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/agents/fullscreen_dialog_agent/fullscreen_dialog_agent.dart';

/// Show params for [FullScreenDialogAgent]
class FullScreenShowParams extends AgentShowParams {
  /// Custom animation of presented content inside the dialog
  final IEasyAnimator? customContentAnimation;

  /// Custom animation of background of the dialog
  final IEasyAnimator? customBackgroungAnimation;

  /// Background color
  /// Is not used, when [customBackgroungAnimation] is provided
  final Color? backgroundColor;

  /// Callback for dismissing the dialog
  /// The dialog isn't dismissible by tap if it isn't provided
  final EasyDismissCallback? onDismissed;

  /// Type of background pre-built animation
  final EasyFullScreenBackgroungAnimationType backgroungAnimationType;

  /// Type of appearence pre-built animation of content inside the dialog
  final EasyFullScreenContentAnimationType contentAnimationType;

  /// Creates an instance of [FullScreenShowParams]
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
