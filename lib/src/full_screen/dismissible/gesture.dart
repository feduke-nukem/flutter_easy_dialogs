part of 'easy_full_screen_dismissible.dart';

/// Simple tap gesture dismissible.
class _Gesture extends EasyFullScreenDismissible {
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
    final data = EasyDialogScope.of<EasyDismissibleScopeData>(context);

    return GestureDetector(
      onTap: () {
        data.handleDismiss?.call();
        onDismiss?.call();
      },
      child: child,
    );
  }
}
