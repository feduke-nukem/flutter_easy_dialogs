part of 'easy_full_screen_dismissible.dart';

class _None extends EasyFullScreenDismissible {
  const _None() : super(onDismiss: null);

  @override
  Widget makeDismissible(Widget dialog) => dialog;
}
