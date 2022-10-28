import 'package:flutter_easy_dialogs/src/core/agents/compose_interfaces.dart';
import 'package:flutter_easy_dialogs/src/core/dismissibles/easy_dismissible.dart';
import 'package:flutter_easy_dialogs/src/core/dismissibles/types/easy_positioned_dismissible_type.dart';

abstract class IEasyDismissibleFactory {
  IEasyDismissor createDismissible(covariant DismissibleCreateParams params);
}

class DismissibleCreateParams implements IDissmisableSettings {
  const DismissibleCreateParams({
    required this.dismissibleType,
    required this.onDismissed,
  });

  @override
  final EasyPositionedDismissibleType dismissibleType;

  @override
  final EasyDismissCallback onDismissed;
}
