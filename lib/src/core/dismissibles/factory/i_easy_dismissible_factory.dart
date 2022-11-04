import 'package:flutter_easy_dialogs/src/core/dismissibles/easy_dismissible.dart';
import 'package:flutter_easy_dialogs/src/core/dismissibles/types/easy_positioned_dismissible_type.dart';

abstract class IEasyDismissibleFactory {
  IEasyDismissor createDismissible(covariant DismissibleCreateParams params);
}

class DismissibleCreateParams {
  const DismissibleCreateParams({
    required this.dismissibleType,
    required this.onDismissed,
  });

  final EasyPositionedDismissibleType dismissibleType;

  final EasyDismissCallback onDismissed;
}
