import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/util/extensions/easy_dialog_position_x.dart';

/// Expansion animation
class EasyExpansionAnimation extends EasyAnimation {
  final _tween = Tween<double>(
    begin: 0.0,
    end: 1.0,
  );

  /// Dialog position
  final EasyDialogPosition position;

  /// Creates an instance of [EasyExpansionAnimation]
  EasyExpansionAnimation({
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
      child: EasyExpansionTransition(
        expansion: curve != null
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
}
