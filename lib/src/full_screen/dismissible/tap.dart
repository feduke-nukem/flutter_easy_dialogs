part of 'full_screen_dismiss.dart';

final class _Tap extends FullScreenDismiss {
  final HitTestBehavior behavior;

  const _Tap({
    this.behavior = HitTestBehavior.opaque,
    super.onDismissed,
  });

  @override
  Widget call(
    EasyDialogContext<FullScreenDialog> context,
  ) {
    return GestureDetector(
      onTap: () => handleDismiss(context),
      behavior: behavior,
      child: context.content,
    );
  }

  @override
  Future<void> handleDismiss(
    EasyDialogContext<FullScreenDialog> context,
  ) async {
    if (context.dialog.androidWillPop == null)
      return super.handleDismiss(context);

    final canPop = await context.dialog.androidWillPop?.call() ?? false;

    if (!canPop) return;

    return context.hideDialog(result: onDismissed?.call());
  }
}
