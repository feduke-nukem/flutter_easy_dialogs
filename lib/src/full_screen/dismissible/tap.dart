part of 'full_screen_dismissible.dart';

final class _Tap extends FullScreenDismissible {
  const _Tap({
    this.behavior = HitTestBehavior.opaque,
    super.onDismissed,
    super.hideOnDismiss,
  });

  final HitTestBehavior behavior;

  @override
  Widget call(FullScreenDialog dialog) {
    return GestureDetector(
      onTap: () => super.handleDismiss(dialog),
      behavior: behavior,
      child: dialog.child,
    );
  }
}
