import 'package:flutter/widgets.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/managers/easy_dialog_manager_base.dart';
import 'package:flutter_easy_dialogs/src/core/managers/full_screen_dialog_manager/full_screen_dialog_manager.dart';

/// Show params for [FullScreenDialogManager]
class FullScreenShowParams extends ManagerShowParamsBase {
  /// Custom animation of presented content inside the dialog
  final IEasyAnimator? customContentAnimation;

  /// Custom animation of background of the dialog
  final IEasyAnimator? customBackgroundAnimation;

  /// Background color
  /// Is not used, when [customBackgroundAnimation] is provided
  final Color? backgroundColor;

  /// Callback for dismissing the dialog
  /// The dialog isn't dismissible by tap if it isn't provided
  final EasyDismissCallback? onDismissed;

  /// Type of background pre-built animation
  final EasyFullScreenBackgroundAnimationType backgroundAnimationType;

  /// Type of appearance pre-built animation of content inside the dialog
  final EasyFullScreenContentAnimationType contentAnimationType;

  /// Creates an instance of [FullScreenShowParams]
  const FullScreenShowParams({
    required super.theme,
    required super.content,
    required this.backgroundAnimationType,
    required this.contentAnimationType,
    this.onDismissed,
    this.backgroundColor,
    this.customContentAnimation,
    this.customBackgroundAnimation,
  });
}
