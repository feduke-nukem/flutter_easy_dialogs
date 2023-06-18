part of 'full_screen_dismissible.dart';

final class _Tap extends FullScreenDismissible {
  const _Tap({
    this.behavior = HitTestBehavior.opaque,
    super.onDismissed,
  });

  final HitTestBehavior behavior;

  @override
  FullScreenDialog call(FullScreenDialog dialog) {
    return dialog.copyWith(
      child: GestureDetector(
        onTap: () {
          dialog.dismissHandler.call(const EasyDismissiblePayload());
          onDismissed?.call();
        },
        behavior: behavior,
        child: dialog.child,
      ),
    );
  }
}
