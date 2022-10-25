import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/widgets/pre_built_dialogs/easy_banner.dart';

const _durationUntilAutoHide = Duration(seconds: 3);
const _duration = Duration(milliseconds: 300);
const _curve = Curves.fastOutSlowIn;

/// Theme data class that affects [EasyBanner]
class EasyBannerThemeData {
  final Duration durationUntilAutoHide;
  final Duration forwardDuration;
  final Duration reverseDuration;
  final Color backgroundColor;
  final Curve animationCurve;

  const EasyBannerThemeData.raw({
    required this.backgroundColor,
    required this.durationUntilAutoHide,
    required this.forwardDuration,
    required this.reverseDuration,
    required this.animationCurve,
  });

  factory EasyBannerThemeData.light() {
    return const EasyBannerThemeData.raw(
      backgroundColor: Colors.blue,
      durationUntilAutoHide: _durationUntilAutoHide,
      forwardDuration: _duration,
      reverseDuration: _duration,
      animationCurve: _curve,
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
