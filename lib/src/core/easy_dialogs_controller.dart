import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialog_type.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialogs_animation_type.dart';
import 'package:flutter_easy_dialogs/src/widgets/easy_dialogs/easy_dialogs_overlay.dart';
import 'package:flutter_easy_dialogs/src/widgets/easy_dialogs/easy_dialogs_theme.dart';
import 'package:flutter_easy_dialogs/src/widgets/pre_built_dialogs/dialog_banner.dart';

/// Controller for manipulating dialogs via [FlutterEasyDialogs]
class EasyDialogsController {
  /// For manipulating things via [Overlay]
  GlobalKey<EasyDialogsOverlayState> get overlayKey => _overlayKey;

  final _overlayKey = GlobalKey<EasyDialogsOverlayState>();

  /// Data of [EasyDialogsTheme]
  EasyDialogsThemeData _theme;

  /// Need for safe removing previous [OverlayEntry] inside of [Overlay]
  EasyDialogsOverlayEntry? _previousOverlay;

  /// Craetes instance of [EasyDialogsController]
  EasyDialogsController({
    required EasyDialogsThemeData theme,
  }) : _theme = theme;

  @override
  bool operator ==(Object? other) {
    if (identical(this, other)) return true;

    if (runtimeType != other.runtimeType) return false;

    return other is EasyDialogsController &&
        _theme == other._theme &&
        _overlayKey == other._overlayKey;
  }

  @override
  int get hashCode {
    final values = [
      _theme,
      _overlayKey,
    ];

    return Object.hashAll(values);
  }

  EasyDialogsOverlayState get _overlayState => _overlayKey.currentState!;

  /// Updates [EasyDialogsThemeData] of [EasyDialogsController]
  void updateTheme(EasyDialogsThemeData theme) {
    if (theme == _theme) return;

    _theme == theme;
  }

  /// Shows material banner
  void showBanner({
    required Widget content,
    EasyDialogsAnimationType animationType = EasyDialogsAnimationType.slide,
    bool autoHide = false,
  }) {
    _overlayState.removeEntriesByType(EasyDialogType.banner);

    final overlay = EasyDialogsOverlayEntry(
      type: EasyDialogType.banner,
      builder: (context) => DialogBanner(
        animationType: animationType,
        child: content,
      ),
    );

    _overlayState.insert(overlay);

    if (!autoHide) return;

    Future.delayed(
      _theme.modalBannerDuration,
      () {
        if (!overlay.mounted) return;

        overlay.remove();
      },
    );
  }
}
