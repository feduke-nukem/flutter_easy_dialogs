import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:positioned_dialog_manager/src/manager/positioned_dialog_manager.dart';

extension PositionedDialogManagerRegistrarX on IEasyDialogManagerRegistry {
  void registerPositioned(IEasyOverlayController overlayController) => register(
      () => PositionedDialogManager(overlayController: overlayController));
}
