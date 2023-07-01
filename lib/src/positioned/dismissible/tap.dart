part of 'positioned_dismiss.dart';

final class _Tap extends PositionedDismiss {
  final HitTestBehavior? behavior;
  const _Tap({
    this.behavior,
    super.onDismissed,
    super.willDismiss,
  });

  @override
  Widget call(
    EasyDialogContext<PositionedDialog> context,
  ) {
    return GestureDetector(
      onTap: () => super.handleDismiss(context),
      behavior: behavior,
      child: context.content,
    );
  }
}
