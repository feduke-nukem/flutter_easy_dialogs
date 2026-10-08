part of 'tooltip_shell.dart';

/// Tooltip bubble.
final class _Bubble extends TooltipShell {
  /// Background color.
  ///
  /// Use [ColorScheme.inverseSurface] if null.
  final Color? backgroundColor;

  /// Padding.
  final EdgeInsets padding;

  /// Border radius.
  final BorderRadius borderRadius;

  /// Border.
  final BorderSide side;

  /// Distance from the bubble to the arrow tip.
  final double arrowLength;

  /// Width of the arrow where it meets the bubble.
  final double arrowBaseWidth;

  /// Shadows.
  final List<BoxShadow> shadows;

  /// Text style.
  ///
  /// Use [ColorScheme.onInverseSurface] color if null.
  final TextStyle? textStyle;

  /// Creates an instance of [_Bubble].
  const _Bubble({
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.side = BorderSide.none,
    this.arrowLength = 8.0,
    this.arrowBaseWidth = 16.0,
    this.shadows = const [],
    this.textStyle,
  });

  @override
  Widget call(TooltipDialog dialog) {
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final arrowSide = TooltipBubbleBorder.arrowSideOf(dialog.alignment);
        final shift = TooltipDialog.shiftOf(context);

        TooltipBubbleBorder border() => TooltipBubbleBorder(
              arrowSide: arrowSide,
              arrowAlignment:
                  TooltipBubbleBorder.arrowAlignmentOf(dialog.alignment),
              // Keep pointing at the target when the bubble is shifted.
              arrowOffset: switch (arrowSide) {
                AxisDirection.up || AxisDirection.down => -shift.value.dx,
                AxisDirection.left || AxisDirection.right => -shift.value.dy,
                null => 0.0,
              },
              arrowLength: arrowLength,
              arrowBaseWidth: arrowBaseWidth,
              borderRadius: borderRadius,
              side: side,
            );

        return CustomPaint(
          painter: _BubblePainter(
            border: border,
            color: backgroundColor ?? colorScheme.inverseSurface,
            shadows: shadows,
            repaint: shift,
          ),
          child: Padding(
            padding: border().dimensions.add(padding),
            child: DefaultTextStyle.merge(
              style: TextStyle(color: colorScheme.onInverseSurface)
                  .merge(textStyle),
              child: dialog.content,
            ),
          ),
        );
      },
    );
  }
}

class _BubblePainter extends CustomPainter {
  final TooltipBubbleBorder Function() border;
  final Color color;
  final List<BoxShadow> shadows;

  _BubblePainter({
    required this.border,
    required this.color,
    required this.shadows,
    super.repaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final border = this.border();
    final path = border.getOuterPath(rect);

    for (final shadow in shadows) {
      canvas.drawPath(path.shift(shadow.offset), shadow.toPaint());
    }
    canvas.drawPath(path, Paint()..color = color);
    border.paint(canvas, rect);
  }

  @override
  bool shouldRepaint(_BubblePainter oldDelegate) => true;
}

/// Rounded rectangle with an arrow on the [arrowSide].
///
/// The arrow is placed outside the rectangle, so [dimensions] include
/// [arrowLength] on the [arrowSide].
class TooltipBubbleBorder extends ShapeBorder {
  /// Side of the bubble where the arrow is placed.
  ///
  /// No arrow if null.
  final AxisDirection? arrowSide;

  /// Position of the arrow along the [arrowSide] from -1.0 to 1.0.
  final double arrowAlignment;

  /// Additional offset of the arrow along the [arrowSide] in pixels.
  final double arrowOffset;

  /// Distance from the bubble to the arrow tip.
  final double arrowLength;

  /// Width of the arrow where it meets the bubble.
  final double arrowBaseWidth;

  /// Border radius.
  final BorderRadius borderRadius;

  /// Border.
  final BorderSide side;

  /// Creates an instance of [TooltipBubbleBorder].
  const TooltipBubbleBorder({
    this.arrowSide,
    this.arrowAlignment = 0.0,
    this.arrowOffset = 0.0,
    this.arrowLength = 8.0,
    this.arrowBaseWidth = 16.0,
    this.borderRadius = BorderRadius.zero,
    this.side = BorderSide.none,
  });

  /// The bubble side facing the target for the [TooltipDialog.alignment].
  static AxisDirection? arrowSideOf(Alignment alignment) {
    if (alignment.y < 0) return AxisDirection.down;
    if (alignment.y > 0) return AxisDirection.up;
    if (alignment.x < 0) return AxisDirection.right;
    if (alignment.x > 0) return AxisDirection.left;

    return null;
  }

  /// Arrow position along its side for the [TooltipDialog.alignment],
  /// so it points to the target's anchor.
  static double arrowAlignmentOf(Alignment alignment) =>
      alignment.y == 0.0 ? 0.0 : alignment.x;

  @override
  EdgeInsetsGeometry get dimensions {
    return switch (arrowSide) {
      AxisDirection.up => EdgeInsets.only(top: arrowLength),
      AxisDirection.down => EdgeInsets.only(bottom: arrowLength),
      AxisDirection.left => EdgeInsets.only(left: arrowLength),
      AxisDirection.right => EdgeInsets.only(right: arrowLength),
      null => EdgeInsets.zero,
    }
        .add(EdgeInsets.all(side.width));
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect.deflate(side.width), textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final body = switch (arrowSide) {
      AxisDirection.up => Rect.fromLTRB(
          rect.left, rect.top + arrowLength, rect.right, rect.bottom),
      AxisDirection.down => Rect.fromLTRB(
          rect.left, rect.top, rect.right, rect.bottom - arrowLength),
      AxisDirection.left => Rect.fromLTRB(
          rect.left + arrowLength, rect.top, rect.right, rect.bottom),
      AxisDirection.right => Rect.fromLTRB(
          rect.left, rect.top, rect.right - arrowLength, rect.bottom),
      null => rect,
    };
    final bubble = Path()..addRRect(borderRadius.toRRect(body));

    if (arrowSide == null) return bubble;

    return Path.combine(PathOperation.union, bubble, _arrow(body));
  }

  Path _arrow(Rect body) {
    final vertical =
        arrowSide == AxisDirection.up || arrowSide == AxisDirection.down;
    final halfBase = arrowBaseWidth / 2;
    // Keep the arrow off the rounded corners.
    final inset = halfBase +
        (vertical
            ? math.max(borderRadius.topLeft.x, borderRadius.bottomRight.x)
            : math.max(borderRadius.topLeft.y, borderRadius.bottomRight.y));
    final (min, max) = vertical
        ? (body.left + inset, body.right - inset)
        : (body.top + inset, body.bottom - inset);
    final aligned = vertical
        ? Alignment(arrowAlignment, 0.0).withinRect(body).dx
        : Alignment(0.0, arrowAlignment).withinRect(body).dy;
    final center =
        min > max ? (min + max) / 2 : (aligned + arrowOffset).clamp(min, max);

    final points = switch (arrowSide!) {
      AxisDirection.up => [
          Offset(center - halfBase, body.top),
          Offset(center, body.top - arrowLength),
          Offset(center + halfBase, body.top),
        ],
      AxisDirection.down => [
          Offset(center - halfBase, body.bottom),
          Offset(center, body.bottom + arrowLength),
          Offset(center + halfBase, body.bottom),
        ],
      AxisDirection.left => [
          Offset(body.left, center - halfBase),
          Offset(body.left - arrowLength, center),
          Offset(body.left, center + halfBase),
        ],
      AxisDirection.right => [
          Offset(body.right, center - halfBase),
          Offset(body.right + arrowLength, center),
          Offset(body.right, center + halfBase),
        ],
    };

    return Path()..addPolygon(points, true);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none || side.width == 0.0) return;

    canvas.drawPath(
      getOuterPath(rect.deflate(side.width / 2)),
      side.toPaint(),
    );
  }

  @override
  ShapeBorder scale(double t) => TooltipBubbleBorder(
        arrowSide: arrowSide,
        arrowAlignment: arrowAlignment,
        arrowOffset: arrowOffset * t,
        arrowLength: arrowLength * t,
        arrowBaseWidth: arrowBaseWidth * t,
        borderRadius: borderRadius * t,
        side: side.scale(t),
      );
}
