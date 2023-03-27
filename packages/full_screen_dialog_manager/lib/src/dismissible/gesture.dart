part of 'full_screen_dismissible.dart';

class _Gesture extends FullScreenDismissible {
  final HitTestBehavior behavior;

  const _Gesture({
    this.behavior = HitTestBehavior.opaque,
    super.onDismissed,
  });

  @override
  Widget decorate(EasyDismissibleData data) {
    return GestureDetector(
      onTap: () {
        data.dismissHandler?.call(const EasyDismissiblePayload());
        onDismissed?.call();
      },
      behavior: behavior,
      child: data.dialog,
    );
  }
}
