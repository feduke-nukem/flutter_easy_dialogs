import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/pre_built/easy_banner/easy_banner_theme_data.dart';

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
  final EasyBannerThemeData easyBannerTheme;

  const EasyDialogsThemeData({
    required this.easyBannerTheme,
  });

  factory EasyDialogsThemeData.fallback() => EasyDialogsThemeData.basic();

  factory EasyDialogsThemeData.basic() => EasyDialogsThemeData(
        easyBannerTheme: EasyBannerThemeData.light(),
      );

  EasyDialogsThemeData copyWith({
    EasyBannerThemeData? easyBannerTheme,
  }) =>
      EasyDialogsThemeData(
        easyBannerTheme: easyBannerTheme ?? this.easyBannerTheme,
      );

  @override
  bool operator ==(Object? other) {
    if (identical(this, other)) return true;

    return runtimeType == other.runtimeType &&
        other is EasyDialogsThemeData &&
        easyBannerTheme == other.easyBannerTheme;
  }

  @override
  int get hashCode {
    final values = [easyBannerTheme];

    return Object.hashAll(values);
  }
}
