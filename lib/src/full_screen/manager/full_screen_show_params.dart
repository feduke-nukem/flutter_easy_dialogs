import 'package:flutter_easy_dialogs/src/core/easy_dialog_animator_configuration.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_animator.dart';
import 'package:flutter_easy_dialogs/src/full_screen/animation/easy_full_screen_background_animator/easy_full_screen_background_animator.dart';
import 'package:flutter_easy_dialogs/src/full_screen/animation/easy_full_screen_foreground_animator/easy_full_screen_foreground_animator.dart';
import 'package:flutter_easy_dialogs/src/full_screen/dismissible/easy_full_screen_dismissible.dart';
import 'package:flutter_easy_dialogs/src/full_screen/manager/full_screen_manager.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/full_screen/widgets/easy_full_screen_dialog_shell/easy_full_screen_dialog_shell.dart';

const _defaultDuration = Duration(milliseconds: 300);
const _defaultReverseDuration = Duration(milliseconds: 300);

/// Show params for [FullScreenManager].
class FullScreenShowParams extends EasyDialogManagerShowParams {
  /// Custom animator of presented content inside the dialog.
  final EasyFullScreenForegroundAnimator foregroundAnimator;

  /// Custom animator of background of the dialog.
  final EasyFullScreenBackgroundAnimator backgroundAnimator;

  /// Dismissible.
  final EasyFullScreenDismissible dismissible;

  /// Dialog content shell.
  final EasyFullScreenDialogShell shell;

  final IEasyDialogAnimator? customAnimator;

  /// Creates an instance of [FullScreenShowParams].
  const FullScreenShowParams({
    required super.content,
    super.animationConfiguration = const EasyDialogAnimatorConfiguration(
      duration: _defaultDuration,
      reverseDuration: _defaultReverseDuration,
    ),
    this.customAnimator,
    this.shell = const EasyFullScreenDialogShell.modalBanner(),
    this.dismissible = const EasyFullScreenDismissible.gesture(),
    this.foregroundAnimator = const EasyFullScreenForegroundAnimator.bounce(),
    this.backgroundAnimator = const EasyFullScreenBackgroundAnimator.blur(),
  });
}
