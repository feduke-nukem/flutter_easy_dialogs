import 'package:flutter/widgets.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialogs_animation_type.dart';

const _kCurve = Curves.easeOutCubic;

abstract class EasyDialogsAnimation<T> extends Animation<T> {
  EasyDialogsAnimation({
    required this.parent,
    required T begin,
    required T end,
    this.curve = _kCurve,
  }) : tween = Tween<T>(
          begin: begin,
          end: end,
        );

  /// Type of Animation
  EasyDialogsAnimationType get type;

  /// Returns [Animation] of [T] for this [EasyDialogsAnimation]
  late final Animation<T> animation = CurvedAnimation(
    parent: parent,
    curve: curve,
  ).drive(tween);

  final Tween<T> tween;

  final Animation<double> parent;
  final Curve curve;

  K map<K>({
    required K Function(EasyDialogsSlideAnimation animation) slide,
    required K Function(EasyDialogsFadeAnimation animation) fade,
  });

  @override
  void addListener(VoidCallback listener) => animation.addListener(listener);

  @override
  void addStatusListener(AnimationStatusListener listener) =>
      animation.addStatusListener(listener);

  @override
  void removeListener(VoidCallback listener) =>
      animation.removeListener(listener);

  @override
  void removeStatusListener(AnimationStatusListener listener) =>
      animation.removeStatusListener(listener);

  @override
  AnimationStatus get status => animation.status;

  @override
  T get value => animation.value;
}

class EasyDialogsSlideAnimation<T extends Offset>
    extends EasyDialogsAnimation<T> {
  @override
  EasyDialogsAnimationType type = EasyDialogsAnimationType.slide;

  EasyDialogsSlideAnimation({
    required super.parent,
    required super.begin,
    required super.end,
    super.curve,
  });

  @override
  K map<K>({
    required K Function(EasyDialogsSlideAnimation<Offset> animation) slide,
    required K Function(EasyDialogsFadeAnimation<double> animation) fade,
  }) =>
      slide(this);
}

class EasyDialogsFadeAnimation<T extends double>
    extends EasyDialogsAnimation<T> {
  EasyDialogsFadeAnimation({
    required super.parent,
    required super.begin,
    required super.end,
    super.curve,
  });

  @override
  final EasyDialogsAnimationType type = EasyDialogsAnimationType.fade;

  @override
  K map<K>({
    required K Function(EasyDialogsSlideAnimation<Offset> animation) slide,
    required K Function(EasyDialogsFadeAnimation<double> animation) fade,
  }) =>
      fade(this);
}
