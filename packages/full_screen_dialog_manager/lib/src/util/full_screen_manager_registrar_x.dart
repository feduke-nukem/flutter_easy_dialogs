import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:full_screen_dialog_manager/src/manager/full_screen_dialog_manager.dart';

extension FullScreenManagerRegistrarX on IEasyDialogManagerRegistry {
  void registerFullScreen(IEasyOverlayController overlayController) => register(
      () => FullScreenDialogManager(overlayController: overlayController));
}
