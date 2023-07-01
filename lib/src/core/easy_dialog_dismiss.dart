part of 'easy_dialogs_controller.dart';

/// {@category Decorators}
/// {@category Custom}
/// Dismiss callback.
typedef OnEasyDismissed = FutureOr<Object?> Function();
typedef EasyWillDismiss = Future<bool> Function();

/// {@category Decorators}
/// {@category Custom}
/// The main purpose is to make provided [EasyDismissibleData.dialog]
/// dismissible.
///
/// It is often used in the [EasyDialogsController.show] method,
/// which provides the dialog to be used in the [call] method.
///
/// This may help you understand how it is supposed to work or even
/// create your own [EasyDialogsController].
abstract base class EasyDialogDismiss<Dialog extends EasyDialog>
    extends EasyDialogDecoration<Dialog> {
  /// Callback that fires when dialog get dismissed.
  final OnEasyDismissed? onDismissed;
  final EasyWillDismiss? willDismiss;

  /// Creates an instance of [EasyDialogDismiss].
  const EasyDialogDismiss({
    this.onDismissed,
    this.willDismiss,
  });

  @protected
  bool get instantly => false;

  @protected
  Future<void> handleDismiss(EasyDialogContext<Dialog> dialogContext) async {
    final parentDismiss = dialogContext
        .getParentDecorationOfType<EasyDialogDismiss<Dialog>>(this);
    final effectiveWillDismiss = willDismiss ?? parentDismiss?.willDismiss;
    final effectiveOnDismissed = onDismissed ?? parentDismiss?.onDismissed;

    if (await effectiveWillDismiss?.call() ?? true)
      dialogContext.hideDialog(
        result: effectiveOnDismissed?.call(),
        instantly: instantly,
      );
  }
}
