import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/agents/positioned_dialog_agent.dart/positioned_dialog_agent.dart';

/// Show params of [PositionedDialogAgent]
class PositionedDialogShowParams extends AgentShowParams {
  /// Position where the dialog will be shown
  final EasyDialogPosition position;

  /// If is true, the dialog will hide after [durationUntilHide]
  final bool autoHide;

  /// Duration until the dialog will be hidden
  final Duration? durationUntilHide;

  /// The type of dismissing the dialog
  final EasyPositionedDismissibleType dismissibleType;

  /// Callback that fires when the dialog is dismissed
  final EasyDismissCallback? onDismissed;

  /// Creates an instance of [PositionedDialogShowParams]
  const PositionedDialogShowParams({
    required super.theme,
    required super.content,
    required this.position,
    this.dismissibleType = EasyPositionedDismissibleType.none,
    this.autoHide = false,
    this.onDismissed,
    this.durationUntilHide,
    super.animationSettings,
  });
}
