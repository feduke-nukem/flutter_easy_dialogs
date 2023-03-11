import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/util/extensions/easy_dialog_position_x.dart';

/// Vertical slide animation
class EasyVerticalSlideAnimation extends EasyAnimation {
  late final _tween = _createTweenOfPosition();

  /// Dialog position
  final EasyDialogPosition position;

  /// Creates an instance of [EasyVerticalSlideAnimation]
  EasyVerticalSlideAnimation({
    super.curve,
    required this.position,
  });

  @override
  Widget animate({
    required Animation<double> parent,
    required Widget child,
  }) {
    return Align(
      alignment: position.toAlignment(),
      child: SlideTransition(
        position: curve != null
            ? parent.drive(
                _tween.chain(
                  CurveTween(curve: curve!),
                ),
              )
            : _tween.animate(parent),
        child: child,
      ),
    );
  }

  Tween<Offset> _createTweenOfPosition() {
    switch (position) {
      case EasyDialogPosition.top:
        return Tween<Offset>(
          begin: const Offset(0.0, -1.0),
          end: const Offset(0.0, 0.0),
        );

      case EasyDialogPosition.bottom:
        return Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: const Offset(0.0, 0.0),
        );

      case EasyDialogPosition.center:
        return Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: const Offset(0.0, 0.0),
        );
    }
  }
}
