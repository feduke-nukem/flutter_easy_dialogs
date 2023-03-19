import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';

abstract class CustomManager<S extends EasyDialogManagerShowParams?,
    H extends EasyDialogManagerHideParams?> extends EasyDialogManager<S, H> {
  CustomManager({required super.overlayController});
}
