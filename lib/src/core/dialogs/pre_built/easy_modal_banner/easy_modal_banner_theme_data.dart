import 'package:flutter/material.dart';

const _margin = EdgeInsets.symmetric(horizontal: 15.0);
const _padding = EdgeInsets.all(60.0);

class EasyModalBannerThemeData {
  final BoxDecoration decoration;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const EasyModalBannerThemeData({
    required this.decoration,
    required this.margin,
    required this.padding,
  });

  factory EasyModalBannerThemeData.light() {
    return EasyModalBannerThemeData(
      decoration: BoxDecoration(
        color: Colors.grey.shade200.withOpacity(0.3),
      ),
      margin: _margin,
      padding: _padding,
    );
  }

  @override
  bool operator ==(Object? other) {
    if (identical(this, other)) return true;

    return runtimeType == other.runtimeType &&
        other is EasyModalBannerThemeData &&
        decoration == other.decoration &&
        padding == other.padding &&
        margin == other.margin;
  }

  @override
  int get hashCode {
    final values = [
      decoration,
      padding,
      margin,
    ];

    return Object.hashAll(values);
  }

  EasyModalBannerThemeData copyWith({
    BoxDecoration? decoration,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    return EasyModalBannerThemeData(
      decoration: decoration ?? this.decoration,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
    );
  }
}
