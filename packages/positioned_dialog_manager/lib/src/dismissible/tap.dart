part of 'positioned_dismissible.dart';

class _Tap extends PositionedDismissible {
  final HitTestBehavior? behavior;

  const _Tap({this.behavior, super.onDismissed});

  @override
  Widget decorate(PositionedDismissibleData data) {
    return GestureDetector(
      behavior: behavior,
      onTap: () {
        data.dismissHandler?.call(const EasyDismissiblePayload());
        onDismissed?.call();
      },
      child: data.dialog,
    );
  }
}
