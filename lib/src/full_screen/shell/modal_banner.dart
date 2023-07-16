part of 'full_screen_shell.dart';

final class _ModalBanner extends FullScreenShell {
  final EdgeInsets padding;

  final EdgeInsets margin;

  final BoxDecoration? boxDecoration;

  const _ModalBanner({
    this.padding = const EdgeInsets.all(60.0),
    this.margin = const EdgeInsets.symmetric(horizontal: 15.0),
    this.boxDecoration,
  });

  @override
  Widget call(FullScreenDialog dialog) {
    return Center(
      child: Container(
        padding: padding,
        decoration: boxDecoration,
        margin: margin,
        child: dialog.content,
      ),
    );
  }
}
