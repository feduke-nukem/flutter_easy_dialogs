part of 'positioned_dismissible.dart';

final class _Tap extends PositionedDismissible {
  const _Tap({
    this.behavior,
    super.onDismissed,
    super.hideOnDismiss,
  });

  final HitTestBehavior? behavior;

  @override
  Widget call(PositionedDialog dialog) {
    return GestureDetector(
      onTap: () {
        dialog.requestHide();
        onDismissed?.call();
      },
      behavior: behavior,
      child: dialog.child,
    );
  }
}
