part of 'positioned_dismissible.dart';

class _Gesture extends PositionedDismissible {
  const _Gesture({super.onDismissed});

  @override
  Widget decorate(EasyDismissibleData data) {
    return GestureDetector(
      onTap: () {
        data.handleDismiss?.call();
        onDismissed?.call();
      },
      child: data.dialog,
    );
  }
}
