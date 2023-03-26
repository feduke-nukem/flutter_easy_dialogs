import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

/// An interface for providing access to [EasyDialogManager] instances.
///
/// Implementations of this interface are responsible for retrieving
/// a particular instance of [EasyDialogManager] by type with the help of
/// [get] method.
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
  M get<M extends EasyDialogManager>();
}
