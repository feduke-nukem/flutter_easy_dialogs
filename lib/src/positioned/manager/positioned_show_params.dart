import 'package:flutter_easy_dialogs/src/core/easy_dialog_animator_configuration.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/positioned/animation/easy_positioned_animator.dart';
import 'package:flutter_easy_dialogs/src/positioned/dismissible/easy_positioned_dismissible.dart';
import 'package:flutter_easy_dialogs/src/positioned/easy_dialog_position.dart';
import 'package:flutter_easy_dialogs/src/positioned/manager/positioned_manager.dart';
import 'package:flutter_easy_dialogs/src/positioned/widgets/easy_positioned_dialog_shell/easy_positioned_dialog_shell.dart';

const _defaultDuration = Duration(milliseconds: 500);
const _defaultReverseDuration = Duration(milliseconds: 500);

/// Show params of [PositionedManager].
class PositionedShowParams extends EasyDialogManagerShowParams {
  /// Position where the dialog will be shown.
  final EasyDialogPosition position;

  final EasyPositionedAnimator animator;

  /// If is true, the dialog will hide after [durationUntilHide].
  final bool autoHide;

  /// Duration until the dialog will be hidden.
  final Duration durationUntilHide;

  final EasyPositionedDismissible dismissible;

  /// Dialog shell. Representing the wrapper around [content].
  final EasyPositionedDialogShell shell;

  /// Creates an instance of [PositionedShowParams].
  const PositionedShowParams({
    required super.content,
    this.position = EasyDialogPosition.top,
    this.dismissible = const EasyPositionedDismissible.tap(),
    this.durationUntilHide = const Duration(seconds: 3),
    this.animator = const EasyPositionedAnimator.fade(),
    this.shell = const EasyPositionedDialogShell.banner(),
    this.autoHide = false,
    super.animationConfiguration = const EasyDialogAnimatorConfiguration(
      duration: _defaultDuration,
      reverseDuration: _defaultReverseDuration,
    ),
  });
}
