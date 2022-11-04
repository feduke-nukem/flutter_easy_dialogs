import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/pre_built/easy_banner/easy_banner_theme_data.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/pre_built/easy_modal_banner/easy_modal_banner_theme_data.dart';

class FlutterEasyDialogsTheme extends StatelessWidget {
  final FlutterEasyDialogsThemeData data;
  final Widget child;

  const FlutterEasyDialogsTheme({
    required this.data,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _EasyDialogsInheritedTheme(
      theme: this,
      child: child,
    );
  }

  static FlutterEasyDialogsThemeData of(BuildContext context) {
    final inheritedTheme = context
        .dependOnInheritedWidgetOfExactType<_EasyDialogsInheritedTheme>();

    return inheritedTheme?.theme.data ?? FlutterEasyDialogsThemeData.fallback();
  }
}

/// Inherited
class _EasyDialogsInheritedTheme extends InheritedTheme {
  final FlutterEasyDialogsTheme theme;

  const _EasyDialogsInheritedTheme({
    required super.child,
    required this.theme,
  });

  @override
  bool updateShouldNotify(covariant _EasyDialogsInheritedTheme oldWidget) =>
      oldWidget.theme.data != theme.data;

  @override
  Widget wrap(BuildContext context, Widget child) => FlutterEasyDialogsTheme(
        data: theme.data,
        child: child,
      );
}

class FlutterEasyDialogsThemeData with Diagnosticable {
  final EasyBannerThemeData easyBannerTheme;
  final EasyModalBannerThemeData easyModalBannerTheme;

  const FlutterEasyDialogsThemeData({
    required this.easyBannerTheme,
    required this.easyModalBannerTheme,
  });

  factory FlutterEasyDialogsThemeData.fallback() =>
      FlutterEasyDialogsThemeData.basic();

  factory FlutterEasyDialogsThemeData.basic() => FlutterEasyDialogsThemeData(
        easyBannerTheme: EasyBannerThemeData.light(),
        easyModalBannerTheme: EasyModalBannerThemeData.light(),
      );

  FlutterEasyDialogsThemeData copyWith({
    EasyBannerThemeData? easyBannerTheme,
    EasyModalBannerThemeData? easyModalBannerTheme,
    Color? fullscreenDialogBackgroundColor,
  }) =>
      FlutterEasyDialogsThemeData(
        easyBannerTheme: easyBannerTheme ?? this.easyBannerTheme,
        easyModalBannerTheme: easyModalBannerTheme ?? this.easyModalBannerTheme,
      );

  @override
  bool operator ==(Object? other) {
    if (identical(this, other)) return true;

    return runtimeType == other.runtimeType &&
        other is FlutterEasyDialogsThemeData &&
        easyBannerTheme == other.easyBannerTheme &&
        easyModalBannerTheme == other.easyModalBannerTheme;
  }

  @override
  int get hashCode {
    final values = [
      easyBannerTheme,
      easyModalBannerTheme,
    ];

    return Object.hashAll(values);
  }
}
