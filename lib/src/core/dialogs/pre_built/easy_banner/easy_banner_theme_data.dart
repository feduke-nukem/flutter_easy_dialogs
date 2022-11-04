import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/pre_built/easy_banner/easy_banner.dart';

const _durationUntilAutoHide = Duration(seconds: 3);
const _duration = Duration(milliseconds: 500);
const _curve = Curves.fastLinearToSlowEaseIn;
const _margin = EdgeInsets.zero;
const _borderRadius = 0.0;

/// Theme data class that affects [EasyBanner]
class EasyBannerThemeData {
  final Duration durationUntilAutoHide;
  final Duration forwardDuration;
  final Duration reverseDuration;
  final Color backgroundColor;
  final Curve animationCurve;
  final EdgeInsets margin;
  final double radius;

  const EasyBannerThemeData.raw({
    required this.backgroundColor,
    required this.durationUntilAutoHide,
    required this.forwardDuration,
    required this.reverseDuration,
    required this.animationCurve,
    required this.margin,
    required this.radius,
  });

  factory EasyBannerThemeData.light() {
    return const EasyBannerThemeData.raw(
      backgroundColor: Colors.blue,
      durationUntilAutoHide: _durationUntilAutoHide,
      forwardDuration: _duration,
      reverseDuration: _duration,
      animationCurve: _curve,
      margin: _margin,
      radius: _borderRadius,
    );
  }

  @override
  bool operator ==(Object? other) {
    if (identical(this, other)) return true;

    return runtimeType == other.runtimeType &&
        other is EasyBannerThemeData &&
        durationUntilAutoHide == other.durationUntilAutoHide &&
        forwardDuration == other.forwardDuration &&
        reverseDuration == other.reverseDuration &&
        backgroundColor == other.backgroundColor &&
        animationCurve == other.animationCurve;
  }

  @override
  int get hashCode {
    final values = [
      durationUntilAutoHide,
      forwardDuration,
      reverseDuration,
      backgroundColor,
      animationCurve,
    ];

    return Object.hashAll(values);
  }
}
