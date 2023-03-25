part of 'positioned_dismissible.dart';

class _None extends PositionedDismissible {
  const _None({super.onDismissed});

  @override
  Widget decorate(EasyDismissibleData data) => data.dialog;
}
