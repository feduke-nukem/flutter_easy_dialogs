import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

abstract class IPositionable {
  EasyDialogPosition get position;
}

abstract class IAnimatable {
  EasyDialogsAnimationType get animationType;
}

abstract class IAutoHidable {
  bool get autoHide;

  Duration? get durationUntilHide;
}
