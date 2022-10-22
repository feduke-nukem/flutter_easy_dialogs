import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EasyDialogsTheme extends StatelessWidget {
  final EasyDialogsThemeData data;
  final Widget child;

  const EasyDialogsTheme({
    required this.data,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _DialogServiceInheritedTheme(
      theme: this,
      child: child,
    );
  }

  static EasyDialogsThemeData of(BuildContext context) {
    final inheritedTheme = context
        .dependOnInheritedWidgetOfExactType<_DialogServiceInheritedTheme>();

    return inheritedTheme?.theme.data ?? EasyDialogsThemeData.fallback();
  }
}

/// Inherited
class _DialogServiceInheritedTheme extends InheritedTheme {
  final EasyDialogsTheme theme;

  const _DialogServiceInheritedTheme({
    required super.child,
    required this.theme,
  });

  @override
  bool updateShouldNotify(covariant _DialogServiceInheritedTheme oldWidget) =>
      oldWidget.theme.data != theme.data;

  @override
  Widget wrap(BuildContext context, Widget child) => EasyDialogsTheme(
        data: theme.data,
        child: child,
      );
}

class EasyDialogsThemeData with Diagnosticable {
  final Color modalBannerBackgroundColor;
  final TextStyle modalBanerTextStyle;
  final Duration modalBannerDuration;

  const EasyDialogsThemeData({
    required this.modalBanerTextStyle,
    required this.modalBannerBackgroundColor,
    required this.modalBannerDuration,
  });

  factory EasyDialogsThemeData.fallback() => EasyDialogsThemeData.basic();

  factory EasyDialogsThemeData.basic() => const EasyDialogsThemeData(
        modalBanerTextStyle: TextStyle(),
        modalBannerBackgroundColor: Colors.white,
        modalBannerDuration: Duration(
          seconds: 3,
        ),
      );

  EasyDialogsThemeData copyWith({
    Color? modalBannerBackgroundColor,
    TextStyle? modalBanerTextStyle,
    Duration? modalBannerDuration,
  }) =>
      EasyDialogsThemeData(
        modalBanerTextStyle: modalBanerTextStyle ?? this.modalBanerTextStyle,
        modalBannerDuration: modalBannerDuration ?? this.modalBannerDuration,
        modalBannerBackgroundColor:
            modalBannerBackgroundColor ?? this.modalBannerBackgroundColor,
      );

  @override
  bool operator ==(Object? other) {
    if (identical(this, other)) return true;

    if (runtimeType != other.runtimeType) return false;

    return other is EasyDialogsThemeData &&
        modalBanerTextStyle == other.modalBanerTextStyle &&
        modalBannerBackgroundColor == other.modalBannerBackgroundColor &&
        modalBannerDuration == other.modalBannerDuration;
  }

  @override
  int get hashCode {
    final values = [
      modalBanerTextStyle,
      modalBannerBackgroundColor,
      modalBannerDuration,
    ];

    return Object.hashAll(values);
  }
}
