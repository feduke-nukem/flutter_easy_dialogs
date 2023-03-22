part of 'easy_positioned_dismissible.dart';

/// Swipe dismissible.
class _Swipe extends EasyDialogDismissible
    implements EasyPositionedDismissible {
  const _Swipe({
    super.onDismiss,
  });

  @override
  Widget makeDismissible(Widget child) {
    return _EasySwipeDismissible(
      onDismiss: super.onDismiss,
      child: child,
    );
  }
}

class _EasySwipeDismissible extends StatelessWidget {
  final Widget child;
  final VoidCallback? onDismiss;

  const _EasySwipeDismissible({
    required this.child,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final data = context.readDialog<EasyDismissibleScopeData>();

    return Dismissible(
      key: UniqueKey(),
      onDismissed: (_) {
        data.handleDismiss?.call();
        onDismiss?.call();
      },
      behavior: HitTestBehavior.deferToChild,
      child: child,
    );
  }
}
