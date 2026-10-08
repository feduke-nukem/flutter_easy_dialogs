import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import '../../core/core.dart';

part 'easy_tooltip_target.dart';
part 'tooltip_follower.dart';

/// [EasyDialog] that is shown next to the [EasyTooltipTarget] with
/// the [targetId] and follows it (e.g. while scrolling).
///
/// The tooltip is kept within the screen: it is shifted along the target's
/// side, and its width is limited by the space next to the target.
///
/// The tooltip is hidden instantly when the target is unmounted.
final class TooltipDialog extends EasyDialog {
  static const defaultAlignment = Alignment.topCenter;
  static const defaultAnimationConfiguration =
      EasyDialogAnimationConfiguration.bounded(
    duration: Duration(milliseconds: 200),
    reverseDuration: Duration(milliseconds: 200),
  );

  /// Minimal distance from the tooltip to the screen edges
  /// (in addition to the safe area).
  static const screenMargin = EdgeInsets.all(8.0);

  // Shared between clones made by decorations.
  var _shared = _TooltipShared();

  /// [EasyTooltipTarget.id] of the target to show the tooltip at.
  final Object targetId;

  /// Where the tooltip is placed relative to the target.
  ///
  /// * [Alignment.topCenter] - above the target, centered.
  /// * [Alignment.topLeft] - above the target, left edges are aligned.
  /// * [Alignment.topRight] - above the target, right edges are aligned.
  /// * [Alignment.centerLeft] - to the left of the target, centered.
  /// * [Alignment.center] - over the target, centered.
  ///
  /// The same goes for the bottom and right ones.
  final Alignment alignment;

  /// Additional offset applied to the tooltip.
  final Offset offset;

  /// Creates an instance of [TooltipDialog].
  ///
  /// If [id] is not provided, [targetId] is used.
  TooltipDialog({
    required super.content,
    required this.targetId,
    this.alignment = defaultAlignment,
    this.offset = Offset.zero,
    super.decoration,
    super.animationConfiguration = defaultAnimationConfiguration,
    super.autoHideDuration,
    Object? id,
  }) : super(id: id ?? targetId);

  /// The point of the tooltip that is attached to the [alignment] point of
  /// the target.
  Alignment get followerAnchor => alignment.y == 0.0
      ? Alignment(-alignment.x, 0.0)
      : Alignment(alignment.x, -alignment.y);

  /// Offset the tooltip was shifted by to stay within the screen.
  ///
  /// Shells use it to keep pointing at the target
  /// (e.g. [TooltipShell.bubble] arrow).
  static ValueListenable<Offset> shiftOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_TooltipShiftScope>()?.shift ??
      const _ZeroShift();

  /// Makes [child] follow the target.
  ///
  /// Applied automatically on insert. Decorations that cover the whole screen
  /// (e.g. [EasyDialogAnimation.blurBackground]) call it on the dialog content
  /// themselves, so only the content follows the target.
  Widget follow(Widget child) {
    _shared.followApplied = true;

    return _TooltipFollower(dialog: this, child: child);
  }

  @override
  EasyOverlayBoxInsertion createInsert(Widget decorated) {
    return super.createInsert(
      _shared.followApplied ? decorated : follow(decorated),
    );
  }

  @override
  void onHide() {
    super.onHide();
    _shared.hiding = true;
  }

  @override
  void onHidden() {
    super.onHidden();
    _shared.hiding = true;
  }

  @override
  EasyDialog clone() {
    return TooltipDialog(
      content: content,
      targetId: targetId,
      alignment: alignment,
      offset: offset,
      decoration: decoration,
      animationConfiguration: animationConfiguration,
      autoHideDuration: autoHideDuration,
      id: id,
    ).._shared = _shared;
  }
}

class _TooltipShared {
  var followApplied = false;
  var hiding = false;
}
