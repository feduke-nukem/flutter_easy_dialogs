part of 'positioned_dismissible.dart';

class _Gesture extends PositionedDismissible {
  const _Gesture({super.onDismissed});

  @override
  Widget decorate(PositionedDismissibleData data) {
    return GestureDetector(
      onTap: () {
        data.dismissHandler?.call(const EasyDismissiblePayload());
        onDismissed?.call();
      },
      child: data.dialog,
    );
  }
}
