import 'package:flutter/material.dart';

import '../../core/core.dart';

/// [EasyDialog] that is shown at a specific [EasyDialogPosition].
final class PositionedDialog extends EasyDialog {
  static const defaultPosition = EasyDialogPosition.top;
  static const defaultAnimationConfiguration =
      const EasyDialogAnimationConfiguration.bounded(
    duration: Duration(milliseconds: 500),
    reverseDuration: Duration(milliseconds: 500),
  );
  static const defaultAutoHideDuration = Duration(seconds: 3);

  /// The position where the dialog will be shown.
  final EasyDialogPosition position;

  final bool isDraggable;

  /// Creates an instance of [PositionedDialog].
  PositionedDialog({
    required super.content,
    this.position = defaultPosition,
    this.isDraggable = false,
    super.decoration,
    super.animationConfiguration = defaultAnimationConfiguration,
    super.autoHideDuration = defaultAutoHideDuration,
  });

  @factory
  static EasyDialogIdentifier identifier({
    required EasyDialogPosition position,
  }) {
    return ValueDialogIdentifier(position);
  }

  @override
  EasyDialogPosition get identity => position;

  @override
  EasyOverlayBoxInsertion<EasyDialog> createInsert(Widget decorated) {
    return PositionedDialogInsert(
      position: position,
      dialog: isDraggable
          ? _FreePositioned(
              alignment: position.alignment,
              child: decorated,
            )
          : Align(
              alignment: position.alignment,
              child: decorated,
            ),
    );
  }

  @override
  EasyOverlayBoxRemoval<EasyDialog> createRemove() =>
      PositionedDialogRemove(position: position);

  @override
  EasyDialog clone() {
    return PositionedDialog(
      content: content,
      position: position,
      decoration: decoration,
      animationConfiguration: animationConfiguration,
      autoHideDuration: autoHideDuration,
    );
  }
}

/// Enum that represents the position of the dialog.
enum EasyDialogPosition {
  top(Alignment.topCenter),
  bottom(Alignment.bottomCenter),
  center(Alignment.center);

  final AlignmentGeometry alignment;

  const EasyDialogPosition(this.alignment);
}

@visibleForTesting
final class PositionedDialogInsert
    extends EasyOverlayBoxInsertion<PositionedDialog> {
  final EasyDialogPosition position;

  const PositionedDialogInsert({
    required this.position,
    required super.dialog,
  });

  @override
  EasyOverlayEntry call(EasyDialogsOverlayBox box) {
    final container =
        box.putIfAbsent<Map<EasyDialogPosition, EasyOverlayEntry>>(
      dialogType,
      () => <EasyDialogPosition, EasyOverlayEntry>{},
    );
    assert(
      !container.containsKey(position),
      'only single one $EasyDialogsOverlayEntry with the same $EasyDialogPosition can be presented at the same time',
    );

    final entry = EasyDialogsOverlayEntry(
      builder: (_) => dialog,
    );

    container[position] = entry;

    return entry;
  }
}

@visibleForTesting
final class PositionedDialogRemove
    extends EasyOverlayBoxRemoval<PositionedDialog> {
  final EasyDialogPosition position;

  const PositionedDialogRemove({
    required this.position,
  });

  @override
  EasyOverlayEntry? call(EasyDialogsOverlayBox box) {
    final container =
        box.get<Map<EasyDialogPosition, EasyOverlayEntry>>(dialogType);

    assert(container != null, 'entries container is not initialized');

    if (container!.entries.isEmpty) return null;

    return container.remove(position);
  }
}

class _FreePositioned extends StatefulWidget {
  final Widget child;
  final AlignmentGeometry alignment;

  const _FreePositioned({
    required this.child,
    required this.alignment,
  });

  @override
  State<_FreePositioned> createState() => _FreePositionedState();
}

class _FreePositionedState extends State<_FreePositioned> {
  var _x = 0.0;
  var _y = 0.0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Positioned(
      left: _x,
      top: _y,
      child: GestureDetector(
        onPanUpdate: (details) => setState(
          () {
            _x += details.delta.dx;
            _y += details.delta.dy;
          },
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: screenSize.width,
            maxHeight: screenSize.height,
          ),
          child: Align(
            alignment: widget.alignment,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
