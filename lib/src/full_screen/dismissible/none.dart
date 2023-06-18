part of 'full_screen_dismissible.dart';

base class _None extends FullScreenDismissible {
  const _None() : super(onDismissed: null);

  @override
  EasyDialog call(EasyDialog dialog) => dialog;
}
