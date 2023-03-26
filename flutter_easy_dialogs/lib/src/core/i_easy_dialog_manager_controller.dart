import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

/// Controller for manipulating dialogs via [FlutterEasyDialogs].
abstract class IEasyDialogManagerController {
  /// Get [EasyDialogManager] and use it.
  ///
  /// * Show:
  ///
  /// ```dart
  /// FlutterEasyDialogs.controller.use<MyDialogManager>().show(
  ///       params: const EasyDialogManagerShowParams(
  ///         content: Text('My custom manager'),
  ///       ),
  ///     );
  ///);
  /// ```
  ///
  ///* Hide:
  ///
  /// ```dart
  /// FlutterEasyDialogs.controller.use<MyDialogManager>().hide();
  ///```
  M use<M extends EasyDialogManager>();
}
