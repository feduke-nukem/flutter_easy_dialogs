part of 'full_screen_background_animation.dart';

final class _None extends FullScreenBackgroundAnimation {
  const _None();

  @override
  Widget call(EasyDialog dialog, Widget content) => content;
}
