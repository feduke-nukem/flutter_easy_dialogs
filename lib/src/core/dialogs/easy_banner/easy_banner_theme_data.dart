import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/easy_banner/easy_banner.dart';

const _durationUntilAutoHide = Duration(seconds: 3);
const _duration = Duration(milliseconds: 500);
const _curve = Curves.fastLinearToSlowEaseIn;
const _margin = EdgeInsets.zero;
const _borderRadius = 0.0;

/// Theme data class that affects [EasyBanner]
class EasyBannerThemeData {
  /// Duration until dialog will be hidden if it is marked as autohidable
  final Duration durationUntilAutoHide;

  /// Forward duration of animation
  final Duration forwardDuration;

  /// Reverse duration of animation
  final Duration reverseDuration;

  /// Background color
  final Color backgroundColor;

  /// Animation curve
  final Curve animationCurve;

  /// Margin
  final EdgeInsets margin;

  /// Border radius
  final double borderRadius;

  /// Creates an instance of raw [EasyBannerThemeData]
  const EasyBannerThemeData.raw({
    required this.backgroundColor,
    required this.durationUntilAutoHide,
    required this.forwardDuration,
    required this.reverseDuration,
    required this.animationCurve,
    required this.margin,
    required this.borderRadius,
  });

  /// Creates an instance of ligth version of [EasyBannerThemeData]
  factory EasyBannerThemeData.light() {
    return const EasyBannerThemeData.raw(
      backgroundColor: Colors.blue,
      durationUntilAutoHide: _durationUntilAutoHide,
      forwardDuration: _duration,
      reverseDuration: _duration,
      animationCurve: _curve,
      margin: _margin,
      borderRadius: _borderRadius,
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

  /// Copy with method
  EasyBannerThemeData copyWith({
    Duration? durationUntilAutoHide,
    Duration? forwardDuration,
    Duration? reverseDuration,
    Color? backgroundColor,
    Curve? animationCurve,
    EdgeInsets? margin,
    double? borderRadius,
  }) {
    return EasyBannerThemeData.raw(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      durationUntilAutoHide:
          durationUntilAutoHide ?? this.durationUntilAutoHide,
      forwardDuration: forwardDuration ?? this.forwardDuration,
      reverseDuration: reverseDuration ?? this.reverseDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      margin: margin ?? this.margin,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}
