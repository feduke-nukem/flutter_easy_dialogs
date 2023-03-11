import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/easy_modal_banner/easy_modal_banner.dart';

const _margin = EdgeInsets.symmetric(horizontal: 15.0);
const _padding = EdgeInsets.all(60.0);

/// [EasyModalBanner]'s theme
class EasyModalBannerThemeData {
  /// Decoration
  final BoxDecoration decoration;

  /// Padding
  final EdgeInsets padding;

  /// Margin
  final EdgeInsets margin;

  /// Creates an instance of [EasyModalBannerThemeData]
  const EasyModalBannerThemeData({
    required this.decoration,
    required this.margin,
    required this.padding,
  });

  /// Creates an instance of light version of [EasyModalBannerThemeData]

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

  /// Copy with method
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
