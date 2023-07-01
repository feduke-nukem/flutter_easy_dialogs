part of 'full_screen_dialog_shell.dart';

final class _ModalBanner extends FullScreenDialogShell {
  final EdgeInsets padding;

  final EdgeInsets margin;

  final BoxDecoration? boxDecoration;

  const _ModalBanner({
    this.padding = const EdgeInsets.all(60.0),
    this.margin = const EdgeInsets.symmetric(horizontal: 15.0),
    this.boxDecoration,
  });

  @override
  Widget call(EasyDialogContext<FullScreenDialog> context) {
    return Center(
      child: Container(
        padding: padding,
        decoration: boxDecoration,
        margin: margin,
        child: context.content,
      ),
    );
  }
}
