import 'package:flutter_easy_dialogs/src/core/easy_dialog_animator_configuration.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_animator.dart';
import 'package:flutter_easy_dialogs/src/full_screen/animation/full_screen_background_animator/full_screen_background_animator.dart';
import 'package:flutter_easy_dialogs/src/full_screen/animation/full_screen_foreground_animator/full_screen_foreground_animator.dart';
import 'package:flutter_easy_dialogs/src/full_screen/dismissible/full_screen_dismissible.dart';
import 'package:flutter_easy_dialogs/src/full_screen/manager/full_screen_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/full_screen/widgets/full_screen_dialog_shell/full_screen_dialog_shell.dart';

const _defaultDuration = Duration(milliseconds: 300);
const _defaultReverseDuration = Duration(milliseconds: 300);

/// Show params for [FullScreenDialogManager].
class FullScreenShowParams extends EasyDialogManagerShowParams {
  /// Animator for the foreground of the dialog content.
  final FullScreenForegroundAnimator foregroundAnimator;

  /// Animator for the background of the dialog content.
  final FullScreenBackgroundAnimator backgroundAnimator;

  /// Dismissible.
  final FullScreenDismissible dismissible;

  /// Dialog content shell.
  final FullScreenDialogShell shell;

  /// Extra custom animator.
  ///
  /// If it is not `null`, it will replace both the [foregroundAnimator] and
  /// [backgroundAnimator].
  final EasyDialogAnimator? customAnimator;

  /// Creates an instance of [FullScreenShowParams].
  const FullScreenShowParams({
    required super.content,
    super.animationConfiguration = const EasyDialogAnimatorConfiguration(
      duration: _defaultDuration,
      reverseDuration: _defaultReverseDuration,
    ),
    this.customAnimator,
    this.shell = const FullScreenDialogShell.modalBanner(),
    this.dismissible = const FullScreenDismissible.gesture(),
    this.foregroundAnimator = const FullScreenForegroundAnimator.bounce(),
    this.backgroundAnimator = const FullScreenBackgroundAnimator.blur(),
  });
}
