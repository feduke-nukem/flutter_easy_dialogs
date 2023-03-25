import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';

/// The CustomManager class is an abstract class that
/// extends [EasyDialogManager].
///
/// It is designed to be used as a base class for creating
/// custom managers for specific use cases.

/// The class takes two type parameters: [S] and [H],
/// which represent the types of parameters passed to the [show]
/// and [hide] methods, respectively.
abstract class CustomDialogManager<S extends EasyDialogManagerShowParams?,
    H extends EasyDialogManagerHideParams?> extends EasyDialogManager<S, H> {
  /// @nodoc
  const CustomDialogManager({required super.overlayController});
}
