part of 'positioned_dismissible.dart';

final class _None extends PositionedDismissible {
  const _None() : super(onDismissed: null);

  @override
  Widget call(EasyDialog dialog) => dialog.child;
}
