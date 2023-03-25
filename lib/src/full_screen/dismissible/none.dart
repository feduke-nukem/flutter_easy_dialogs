part of 'full_screen_dismissible.dart';

class _None extends FullScreenDismissible {
  const _None() : super(onDismissed: null);

  @override
  Widget decorate(EasyDismissibleData data) => data.dialog;
}
