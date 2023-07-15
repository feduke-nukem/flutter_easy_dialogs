part of 'positioned_dismiss.dart';

final class _Swipe extends PositionedDismiss {
  final PositionedDismissibleSwipeDirection direction;

  /// A widget that is stacked behind the child. If secondaryBackground is also
  /// specified then this widget only appears when the child has been dragged
  /// down or to the right.
  final Widget? background;

  /// A widget that is stacked behind the child and is exposed when the child
  /// has been dragged up or to the left. It may only be specified when background
  /// has also been specified.
  final Widget? secondaryBackground;

  /// Called when the widget changes size (i.e., when contracting before being dismissed).
  final VoidCallback? onResize;

  /// The amount of time the widget will spend contracting before [onDismissed] is called.
  ///
  /// If null, the widget will not contract and [onDismissed] will be called
  /// immediately after the widget is dismissed.
  final Duration? resizeDuration;

  /// The offset threshold the item has to be dragged in order to be considered
  /// dismissed.
  ///
  /// Represented as a fraction, (e.g.) if it is 0.4 (the default), then the item
  /// has to be dragged at least 40% towards one direction to be considered
  /// dismissed.
  ///
  /// Clients can define different thresholds for each dismiss
  /// direction.
  ///
  /// Flinging is treated as being equivalent to dragging almost to 1.0, so
  /// flinging can dismiss an item past any threshold less than 1.0.
  ///
  /// Setting a threshold of 1.0 (or greater) prevents a drag in the given
  /// [DismissDirection] even if it would be allowed by the [direction]
  /// property.
  ///
  /// See also:
  ///
  ///  * [direction], which controls the directions in which the items can
  ///    be dismissed.
  final Map<DismissDirection, double> dismissThresholds;

  /// Defines the duration for card to dismiss or to come back to original position if not dismissed.
  final Duration movementDuration;

  /// Defines the end offset across the main axis after the card is dismissed.
  ///
  /// If non-zero value is given then widget moves in cross direction depending on whether
  /// it is positive or negative.
  final double crossAxisEndOffset;

  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], the drag gesture used to dismiss a
  /// dismissible will begin at the position where the drag gesture won the arena.
  /// If set to [DragStartBehavior.down] it will begin at the position where
  /// a down event is first detected.
  ///
  /// In general, setting this to [DragStartBehavior.start] will make drag
  /// animation smoother and setting it to [DragStartBehavior.down] will make
  /// drag behavior feel slightly more reactive.
  ///
  /// By default, the drag start behavior is [DragStartBehavior.start].
  ///
  /// See also:
  ///
  /// * [DragGestureRecognizer.dragStartBehavior],
  /// which gives an example for the different behaviors.
  final DragStartBehavior dragStartBehavior;

  /// How to behave during hit tests.
  ///
  /// This defaults to [HitTestBehavior.deferToChild].
  final HitTestBehavior behavior;

  /// Called when the dismissible widget has been dragged.
  ///
  /// If [onUpdate] is not null, then it will be invoked for every pointer event
  /// to dispatch the latest state of the drag. For example, this callback
  /// can be used to for example change the color of the background widget
  /// depending on whether the dismiss threshold is currently reached.
  final DismissUpdateCallback? onUpdate;

  const _Swipe({
    this.direction = PositionedDismissibleSwipeDirection.horizontal,
    super.onDismissed,
    this.background,
    this.behavior = HitTestBehavior.deferToChild,
    this.crossAxisEndOffset = 0.0,
    this.dismissThresholds = const {},
    this.dragStartBehavior = DragStartBehavior.start,
    this.movementDuration = const Duration(milliseconds: 200),
    this.onResize,
    this.onUpdate,
    this.resizeDuration,
    this.secondaryBackground,
    super.willDismiss,
  });

  @override
  bool get instantly => true;

  @override
  Widget call(PositionedDialog dialog) {
    return Dismissible(
      key: UniqueKey(),
      background: background,
      secondaryBackground: secondaryBackground,
      confirmDismiss:
          willDismiss != null ? (_) async => super.willDismiss!() : null,
      onResize: onResize,
      onUpdate: onUpdate,
      onDismissed: (_) => this.handleDismiss(dialog),
      direction: _getDirection(dialog.position),
      resizeDuration: resizeDuration,
      dismissThresholds: dismissThresholds,
      movementDuration: movementDuration,
      crossAxisEndOffset: crossAxisEndOffset,
      dragStartBehavior: dragStartBehavior,
      behavior: behavior,
      child: dialog.content,
    );
  }

  DismissDirection _getDirection(EasyDialogPosition position) =>
      switch (direction) {
        PositionedDismissibleSwipeDirection.horizontal =>
          DismissDirection.horizontal,
        PositionedDismissibleSwipeDirection.vertical =>
          position == EasyDialogPosition.top
              ? DismissDirection.up
              : DismissDirection.down,
      };
}

// no need to name file like this
// ignore: prefer-match-file-name
enum PositionedDismissibleSwipeDirection {
  vertical,
  horizontal,
}
