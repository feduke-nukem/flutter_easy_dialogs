import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/positioned/positioned.dart';

import '../../core/core.dart';

/// [EasyDialog] that is shown at a specific [EasyDialogPosition].
final class PositionedDialog extends EasyDialog {
  static const defaultShell = PositionedDialogShell.banner();
  static const defaultAnimation = EasyDialogAnimation<PositionedDialog>.fade();
  static const defaultDismissible =
      EasyDialogDismiss<PositionedDialog>.animatedTap();

  /// The position where the dialog will be shown.
  final EasyDialogPosition position;

  /// Creates an instance of [PositionedDialog].
  PositionedDialog({
    required super.content,
    this.position = EasyDialogPosition.top,
    super.decoration = const EasyDialogDecoration<PositionedDialog>.combine([
      defaultShell,
      defaultAnimation,
      defaultDismissible,
    ]),
    super.animationConfiguration =
        const EasyDialogAnimationConfiguration.bounded(
      duration: Duration(milliseconds: 500),
      reverseDuration: Duration(milliseconds: 500),
    ),
    super.autoHideDuration = const Duration(seconds: 3),
  });

  @factory
  static PositionedIdentifier identifier({
    required EasyDialogPosition position,
  }) {
    return PositionedIdentifier(position: position);
  }

  @override
  EasyDialogPosition get identity => position;

  @override
  EasyOverlayBoxInsertion<EasyDialog> createInsert(Widget decorated) {
    return PositionedDialogInsert(
      position: position,
      dialog: Align(
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

/// @nodoc
final class PositionedIdentifier extends EasyDialogIdentifier {
  /// Position of the dialog for removing.
  final EasyDialogPosition position;

  /// Creates an instance of [PositionedIdentifier].
  const PositionedIdentifier({required this.position});

  @override
  EasyDialogPosition get identity => position;
}

/// @nodoc
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
