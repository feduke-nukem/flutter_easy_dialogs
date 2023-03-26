part of 'positioned_dismissible.dart';

enum PositionedDismissibleSwipeDirection {
  vertical,
  horizontal,
}

class _Swipe extends PositionedDismissible {
  final PositionedDismissibleSwipeDirection direction;

  /// A widget that is stacked behind the child. If secondaryBackground is also
  /// specified then this widget only appears when the child has been dragged
  /// down or to the right.
  final Widget? background;

  /// A widget that is stacked behind the child and is exposed when the child
  /// has been dragged up or to the left. It may only be specified when background
  /// has also been specified.
  final Widget? secondaryBackground;

  /// Gives the app an opportunity to confirm or veto a pending dismissal.
  ///
  /// The widget cannot be dragged again until the returned future resolves.
  ///
  /// If the returned Future<bool> completes true, then this widget will be
  /// dismissed, otherwise it will be moved back to its original location.
  ///
  /// If the returned Future<bool?> completes to false or null the [onResize]
  /// and [onDismissed] callbacks will not run.
  final ConfirmDismissCallback? confirmDismiss;

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
  /// Represented as a fraction, e.g. if it is 0.4 (the default), then the item
  /// has to be dragged at least 40% towards one direction to be considered
  /// dismissed. Clients can define different thresholds for each dismiss
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
  ///  * [DragGestureRecognizer.dragStartBehavior], which gives an example for the different behaviors.
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
    this.confirmDismiss,
    this.crossAxisEndOffset = 0.0,
    this.dismissThresholds = const {},
    this.dragStartBehavior = DragStartBehavior.start,
    this.movementDuration = const Duration(milliseconds: 200),
    this.onResize,
    this.onUpdate,
    this.resizeDuration,
    this.secondaryBackground,
  });

  @override
  Widget decorate(PositionedDismissibleData data) {
    return Dismissible(
      direction: _getDirection(data.position),
      key: UniqueKey(),
      onDismissed: (_) {
        data.dismissHandler
            ?.call(const EasyDismissiblePayload(instantDismiss: true));
        onDismissed?.call();
      },
      behavior: behavior,
      background: background,
      confirmDismiss: confirmDismiss,
      crossAxisEndOffset: crossAxisEndOffset,
      dismissThresholds: dismissThresholds,
      dragStartBehavior: dragStartBehavior,
      movementDuration: movementDuration,
      onResize: onResize,
      onUpdate: onUpdate,
      resizeDuration: resizeDuration,
      secondaryBackground: secondaryBackground,
      child: data.dialog,
    );
  }

  DismissDirection _getDirection(EasyDialogPosition position) {
    switch (direction) {
      case PositionedDismissibleSwipeDirection.horizontal:
        return DismissDirection.horizontal;
      case PositionedDismissibleSwipeDirection.vertical:
        if (position == EasyDialogPosition.top) return DismissDirection.up;

        return DismissDirection.down;
    }
  }
}
