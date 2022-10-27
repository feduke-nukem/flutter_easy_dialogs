import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/agents/compose_interfaces.dart';
import 'package:flutter_easy_dialogs/src/core/agents/dialog_agent_base.dart';

class PositionedDialogShowParams extends ShowParams
    implements
        IPositionableSettings,
        IAutoHidableSettings,
        IDissmisableSettings {
  @override
  final EasyDialogPosition position;
  @override
  final bool autoHide;

  @override
  final Duration? durationUntilHide;

  @override
  final EasyDismissibleType dismissibleType;

  @override
  final EasyDismissCallback? onDismissed;

  const PositionedDialogShowParams({
    required super.theme,
    required super.content,
    required this.position,
    this.dismissibleType = EasyDismissibleType.none,
    this.autoHide = false,
    this.onDismissed,
    this.durationUntilHide,
    super.animationSettings,
  });
}
