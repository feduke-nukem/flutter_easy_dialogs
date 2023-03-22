part of 'easy_full_screen_dialog_shell.dart';

/// Widget of full screen content appearance.
class _ModalBanner extends EasyFullScreenDialogShell {
  /// Padding.
  final EdgeInsets padding;

  /// Margin.
  final EdgeInsets margin;

  /// Decoration.
  final BoxDecoration? boxDecoration;

  /// Creates an instance of [_ModalBanner].
  const _ModalBanner({
    this.padding = const EdgeInsets.all(60.0),
    this.margin = const EdgeInsets.symmetric(horizontal: 15.0),
    this.boxDecoration,
    super.key,
  });

  @override
  Widget build(BuildContext context, EasyFullScreenScopeData data) {
    return Center(
      child: Container(
        padding: padding,
        decoration: boxDecoration,
        margin: margin,
        child: data.content,
      ),
    );
  }

  @override
  Widget configure(Widget child) {
    // TODO: implement configure
    throw UnimplementedError();
  }
}
