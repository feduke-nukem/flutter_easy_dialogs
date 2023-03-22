part of 'easy_positioned_dialog_shell.dart';

/// Dialog banner.
class _Banner extends EasyPositionedDialogShell {
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
    super.key,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Color?>('backgroundColor', backgroundColor))
      ..add(DiagnosticsProperty<EdgeInsets>('padding', padding));
  }

  @override
  Widget build(BuildContext context, EasyPositionedScopeData data) {
    return Padding(
      padding: margin,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: ColoredBox(
          color: backgroundColor ?? Theme.of(context).primaryColor,
          child: SafeArea(
            top: data.position == EasyDialogPosition.top,
            bottom: data.position == EasyDialogPosition.bottom,
            child: Padding(
              padding: padding,
              child: SizedBox(
                width: double.infinity,
                child: data.content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
