import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/animations/easy_dialogs_slide_from_top_animation.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialog_type.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialogs_animation_type.dart';
import 'package:flutter_easy_dialogs/src/widgets/easy_dialogs/easy_dialogs_overlay.dart';
import 'package:flutter_easy_dialogs/src/widgets/easy_dialogs/easy_dialogs_theme.dart';
import 'package:flutter_easy_dialogs/src/widgets/pre_built_dialogs/dialog_banner.dart';
import 'package:flutter_easy_dialogs/src/widgets/pre_built_dialogs/easy_dialog.dart';

/// Controller for manipulating dialogs via [FlutterEasyDialogs]
class EasyDialogsController {
  /// For manipulating things via [Overlay]
  GlobalKey<EasyDialogsOverlayState> get overlayKey => _overlayKey;

  final _currentDialogs = <IDialogControlPanel>[];

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
  Future<void> showBanner({
    required Widget content,
    EasyDialogsAnimationType animationType =
        EasyDialogsAnimationType.slideFromTop,
    bool autoHide = false,
  }) async {
    for (var dialog in _currentDialogs) {
      await dialog.dismiss();
    }
    _overlayState.removeEntriesByType(EasyDialogType.banner);

    late final IDialogControlPanel dialogControlPanel;

    final overlay = EasyDialogsOverlayEntry(
      type: EasyDialogType.banner,
      builder: (context) => DialogBanner(
        onCotrollPanelCreated: (controlPanel) {
          dialogControlPanel = controlPanel;
          _currentDialogs.add(dialogControlPanel);
        },
        animation: EasyDialogsSlideFromTopAnimation(
          curve: Curves.fastOutSlowIn,
          duration: const Duration(milliseconds: 1000),
          reverseDuration: const Duration(milliseconds: 1000),
        ),
        child: content,
      ),
    );
    _overlayState.insert(overlay);

    if (!autoHide) return;

    Future.delayed(
      _theme.modalBannerDuration,
      () async {
        await dialogControlPanel.dismiss();

        if (!overlay.mounted) return;

        overlay.remove();
        _currentDialogs.remove(dialogControlPanel);
      },
    );
  }
}
