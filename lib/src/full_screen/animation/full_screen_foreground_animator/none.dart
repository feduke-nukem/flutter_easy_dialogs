part of 'full_screen_foreground_animation.dart';

final class _None extends FullScreenForegroundAnimation {
  const _None();

  @override
  Widget call(EasyDialog dialog, Widget content) => content;
}
