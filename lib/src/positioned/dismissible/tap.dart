part of 'positioned_dismiss.dart';

final class _Tap<T> extends PositionedDismiss<T> {
  final HitTestBehavior? behavior;
  const _Tap({
    this.behavior,
    super.onDismissed,
    super.willDismiss,
  });

  @override
  Widget call(PositionedDialog dialog, Widget content) {
    return GestureDetector(
      onTap: () => super.handleDismiss(dialog),
      behavior: behavior,
      child: content,
    );
  }
}
