part of 'full_screen_dismiss.dart';

final class _Tap extends FullScreenDismiss {
  final HitTestBehavior behavior;

  const _Tap({
    this.behavior = HitTestBehavior.opaque,
    super.onDismissed,
  });

  @override
  Widget call(FullScreenDialog dialog) {
    return GestureDetector(
      onTap: () => handleDismiss(dialog),
      behavior: behavior,
      child: dialog.content,
    );
  }

  @override
  Future<void> handleDismiss(FullScreenDialog dialog) async {
    if (dialog.androidWillPop == null) return super.handleDismiss(dialog);

    // this is not testable as it requires a real Android device back button.
    // coverage:ignore-start
    final canPop = await dialog.androidWillPop?.call() ?? false;

    if (!canPop) return;

    return dialog.context.hideDialog(result: onDismissed?.call());
    // coverage:ignore-end
  }
}
