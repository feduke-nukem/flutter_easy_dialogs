part of 'easy_positioned_dismissible.dart';

/// Simple tap gesture dismissible.
class _Gesture extends EasyPositionedDismissible {
  const _Gesture({super.onDismiss});

  @override
  Widget makeDismissible(Widget child) {
    return _EasyGestureDismissible(
      onDismiss: super.onDismiss,
      child: child,
    );
  }
}

class _EasyGestureDismissible extends StatelessWidget {
  final OnEasyDismiss? onDismiss;
  final Widget child;

  const _EasyGestureDismissible({
    this.onDismiss,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final data = context.readDialog<EasyDismissibleScopeData>();

    return GestureDetector(
      onTap: () {
        data.handleDismiss?.call();
        onDismiss?.call();
      },
      child: child,
    );
  }
}
