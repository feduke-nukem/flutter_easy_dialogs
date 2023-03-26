import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:full_screen_dialog_manager/src/manager/full_screen_dialog_manager.dart';

extension FullScreenDialogControllerX on IEasyDialogManagerController {
  Future<void> showFullScreen(FullScreenShowParams params) =>
      use<FullScreenDialogManager>().show(params: params);

  Future<void> hideFullScreen() => use<FullScreenDialogManager>().hide();
}
