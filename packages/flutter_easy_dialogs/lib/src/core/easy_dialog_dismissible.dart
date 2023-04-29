import 'dart:async';

import 'package:flutter_easy_dialogs/src/core/easy_dialog_decorator.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';

/// {@category Decorators}
/// {@category Custom}
/// Dismiss callback.
typedef OnEasyDismissed = void Function();

/// {@category Decorators}
/// {@category Custom}
/// Callback to handle dismiss on a [EasyDialogManager] side.
typedef DismissHandler<P extends EasyDismissiblePayload> = FutureOr<void>
    Function(P payload);

/// {@category Decorators}
/// {@category Custom}
/// The main purpose is to make provided [EasyDismissibleData.dialog]
/// dismissible.
///
/// It is often used in the [EasyDialogManager.show] method,
/// which provides the dialog to be used in the [decorate] method.
///
/// This may help you understand how it is supposed to work or even
/// create your own [EasyDialogManager].
abstract class EasyDialogDismissible<D extends EasyDismissibleData<P>,
    P extends EasyDismissiblePayload> extends EasyDialogDecorator<D> {
  /// Callback that fires when dialog get dismissed.
  final OnEasyDismissed? onDismissed;

  /// Creates an instance of [EasyDialogDismissible].
  const EasyDialogDismissible({this.onDismissed});
}

/// {@category Decorators}
/// {@category Custom}
/// This is specific to the [EasyDialogDismissible] data.
///
/// Sometimes it is necessary to perform certain actions when the actual
/// [EasyDialogDismissible.onDismissed] callback is called.
///
/// For example, in some [EasyDialogManager.show], before the dialog is dismissed,
/// it should trigger the dialog to hide and play an animation back.
///
/// So in this case, it makes sense to provide an optional [dismissHandler]
/// callback to [EasyDialogDismissible] implementations.
class EasyDismissibleData<P extends EasyDismissiblePayload>
    extends EasyDialogDecoratorData {
  /// Optional callback.
  final DismissHandler<P>? dismissHandler;

  /// @nodoc
  const EasyDismissibleData({required super.dialog, this.dismissHandler});
}

/// {@category Decorators}
/// {@category Custom}
/// Sometimes it is necessary to provide some payload to [EasyDialogManager],
/// which is responsible for dismissing the dialog.
///
/// For example, if it is needed to remove the dialog from the overlay
/// instantly without playing any animation or doing anything else.
class EasyDismissiblePayload {
  /// Indicates whether the dialog was dismissed abruptly.

  /// In other words, this means that if the dialog no longer needs to play
  /// any animation before being hidden because
  /// it is already not visible on the screen.
  final bool instantDismiss;

  /// @nodoc
  const EasyDismissiblePayload({this.instantDismiss = false});
}
