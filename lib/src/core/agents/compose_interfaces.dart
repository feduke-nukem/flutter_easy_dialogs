import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

abstract class IPositionableSettings {
  EasyDialogPosition? get position;
}

abstract class IAnimatableSettings {
  EasyAnimationType get animationType;
}

abstract class IAutoHidableSettings {
  bool get autoHide;

  Duration? get durationUntilHide;
}

abstract class IDissmisableSettings {
  EasyDismissibleType get dismissibleType;
  EasyDismissCallback? get onDismissed;
}
