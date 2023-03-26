part of 'positioned_dismissible.dart';

class _None extends PositionedDismissible {
  const _None() : super(onDismissed: null);

  @override
  Widget decorate(PositionedDismissibleData data) => data.dialog;
}
