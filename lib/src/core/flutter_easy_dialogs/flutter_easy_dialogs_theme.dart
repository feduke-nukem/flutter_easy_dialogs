import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/pre_built/easy_modal_banner/easy_modal_banner.dart';

/// Main theme
class FlutterEasyDialogsTheme extends StatelessWidget {
  /// Theme data
  final FlutterEasyDialogsThemeData data;

  /// Child
  final Widget child;

  /// Creates an instance of [FlutterEasyDialogsTheme]
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

  /// Classic of method
  static FlutterEasyDialogsThemeData of(BuildContext context) {
    final inheritedTheme = context
        .dependOnInheritedWidgetOfExactType<_EasyDialogsInheritedTheme>();

    return inheritedTheme?.theme.data ?? FlutterEasyDialogsThemeData.fallback();
  }
}

/// Inherited
class _EasyDialogsInheritedTheme extends InheritedTheme {
  /// Theme
  final FlutterEasyDialogsTheme theme;

  /// Creates an instance of [_EasyDialogsInheritedTheme]
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

/// Data class for the theme
class FlutterEasyDialogsThemeData with Diagnosticable {
  /// [EasyBanner] theme
  final EasyBannerThemeData easyBannerTheme;

  /// [EasyModalBanner] theme
  final EasyModalBannerThemeData easyModalBannerTheme;

  /// Creates an instance of [FlutterEasyDialogsThemeData]
  const FlutterEasyDialogsThemeData({
    required this.easyBannerTheme,
    required this.easyModalBannerTheme,
  });

  /// Creates an instance of fallback version of [FlutterEasyDialogsThemeData]
  factory FlutterEasyDialogsThemeData.fallback() =>
      FlutterEasyDialogsThemeData.basic();

  /// Creates an instance of basic version of [FlutterEasyDialogsThemeData]
  factory FlutterEasyDialogsThemeData.basic() => FlutterEasyDialogsThemeData(
        easyBannerTheme: EasyBannerThemeData.light(),
        easyModalBannerTheme: EasyModalBannerThemeData.light(),
      );

  /// Copy with methid
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
