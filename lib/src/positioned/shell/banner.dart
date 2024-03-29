part of 'positioned_shell.dart';

/// Dialog banner.
final class _Banner extends PositionedShell {
  /// Background color.
  ///
  /// Use [ThemeData.primaryColor] if null.
  final Color? backgroundColor;

  /// Padding.
  final EdgeInsets padding;

  /// Margin.
  final EdgeInsets margin;

  /// Border radius.
  final BorderRadius borderRadius;

  /// Creates an instance of [_Banner].
  const _Banner({
    this.backgroundColor,
    this.padding = const EdgeInsets.all(10.0),
    this.margin = EdgeInsets.zero,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget call(PositionedDialog dialog) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: margin,
          child: ClipRRect(
            borderRadius: borderRadius,
            child: ColoredBox(
              color: backgroundColor ?? Theme.of(context).primaryColor,
              child: SafeArea(
                top: dialog.position == EasyDialogPosition.top,
                bottom: dialog.position == EasyDialogPosition.bottom,
                child: Padding(
                  padding: padding,
                  child: SizedBox(
                    width: double.infinity,
                    child: dialog.content,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
