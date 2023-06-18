part of 'full_screen_dialog_shell.dart';

final class _ModalBanner extends FullScreenDialogShell {
  const _ModalBanner({
    this.padding = const EdgeInsets.all(60.0),
    this.margin = const EdgeInsets.symmetric(horizontal: 15.0),
    this.boxDecoration,
  });

  final EdgeInsets padding;

  final EdgeInsets margin;

  final BoxDecoration? boxDecoration;

  @override
  FullScreenDialog call(FullScreenDialog dialog) {
    return dialog.copyWith(
      child: Center(
        child: Container(
          padding: padding,
          decoration: boxDecoration,
          margin: margin,
          child: dialog.child,
        ),
      ),
    );
  }
}
