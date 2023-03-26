import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

/// An interface for providing access to [EasyDialogManager] instances.
///
/// Implementations of this interface are responsible for retrieving
/// a particular instance of [EasyDialogManager] by type with the help of
/// [use] method.
abstract class IEasyDialogManagerProvider {
  ///
  /// Retrieves an instance of [M], where [M] is a subtype of [EasyDialogManager].
  ///
  /// This method is responsible for returning an instance of the
  /// requested [EasyDialogManager] type.
  ///
  /// If an instance of [M] has already been
  /// registered with the [IEasyDialogManagerRegistry],
  /// this method should return that instance.
  ///
  ///
  /// * Show:
  ///
  /// ```dart
  /// FlutterEasyDialogs.provider.use<MyDialogManager>().show(
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
  /// FlutterEasyDialogs.provider.use<MyDialogManager>().hide();
  ///```
  M use<M extends EasyDialogManager>();
}
