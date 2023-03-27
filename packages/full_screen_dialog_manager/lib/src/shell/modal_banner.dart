part of 'full_screen_dialog_shell.dart';

class _ModalBanner extends FullScreenDialogShell {
  final EdgeInsets padding;

  final EdgeInsets margin;

  final BoxDecoration? boxDecoration;

  const _ModalBanner({
    this.padding = const EdgeInsets.all(60.0),
    this.margin = const EdgeInsets.symmetric(horizontal: 15.0),
    this.boxDecoration,
  });

  @override
  Widget decorate(EasyDialogDecoratorData data) {
    return Center(
      child: Container(
        padding: padding,
        decoration: boxDecoration,
        margin: margin,
        child: data.dialog,
      ),
    );
  }
}
