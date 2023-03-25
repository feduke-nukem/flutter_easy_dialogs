part of 'positioned_dismissible.dart';

/// Swipe dismissible.
class _HorizontalSwipe extends EasyDialogDismissible
    implements PositionedDismissible {
  const _HorizontalSwipe({super.onDismissed});

  @override
  Widget decorate(EasyDismissibleData data) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (_) {
        data.handleDismiss?.call();
        onDismissed?.call();
      },
      behavior: HitTestBehavior.deferToChild,
      child: data.dialog,
    );
  }
}
