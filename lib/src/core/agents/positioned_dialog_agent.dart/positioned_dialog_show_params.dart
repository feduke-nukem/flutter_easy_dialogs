import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

class PositionedDialogShowParams extends AgentShowParams {
  final EasyDialogPosition position;

  final bool autoHide;

  final Duration? durationUntilHide;

  final EasyPositionedDismissibleType dismissibleType;

  final EasyDismissCallback? onDismissed;

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
