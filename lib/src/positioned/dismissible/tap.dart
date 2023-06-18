part of 'positioned_dismissible.dart';

final class _Tap extends PositionedDismissible {
  const _Tap({this.behavior, super.onDismissed});

  final HitTestBehavior? behavior;

  @override
  PositionedDialog call(PositionedDialog dialog) {
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
