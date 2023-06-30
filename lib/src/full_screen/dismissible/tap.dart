part of 'full_screen_dismiss.dart';

final class _Tap<T> extends FullScreenDismiss<T> {
  final HitTestBehavior behavior;

  const _Tap({
    this.behavior = HitTestBehavior.opaque,
    super.onDismissed,
  });

  @override
  Widget call(FullScreenDialog dialog, Widget content) {
    return GestureDetector(
      onTap: () => super.handleDismiss(dialog),
      behavior: behavior,
      child: content,
    );
  }

  @override
  Future<void> handleDismiss(FullScreenDialog dialog) async {
    final canPop = await dialog.willPop?.call() ?? false;

    if (!canPop) return;

    onDismissed?.call();

    return dialog.context.hide();
  }
}
