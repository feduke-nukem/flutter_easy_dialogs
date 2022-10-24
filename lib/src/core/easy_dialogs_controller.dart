import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_factory.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialog_type.dart';
import 'package:flutter_easy_dialogs/src/widgets/easy_dialogs/easy_dialogs_overlay.dart';
import 'package:flutter_easy_dialogs/src/widgets/easy_dialogs/easy_dialogs_theme.dart';
import 'package:flutter_easy_dialogs/src/widgets/pre_built_dialogs/easy_dialog.dart';

import '../animations/animations.dart';

/// Controller for manipulating dialogs via [FlutterEasyDialogs]
class EasyDialogsController {
  /// For manipulating things via [Overlay]
  GlobalKey<EasyDialogsOverlayState> get overlayKey => _overlayKey;

  final _currentBanners = <IDialogControlPanel>[];

  final _overlayKey = GlobalKey<EasyDialogsOverlayState>();

  final IEasyDialogsFactory _easyDialogsFactory;

  /// Data of [EasyDialogsTheme]
  EasyDialogsThemeData _theme;

  /// Craetes instance of [EasyDialogsController]
  EasyDialogsController({
    required EasyDialogsThemeData theme,
    required IEasyDialogsFactory easyDialogsFactory,
  })  : _theme = theme,
        _easyDialogsFactory = easyDialogsFactory;

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
    EasyDialogsPosition position = EasyDialogsPosition.top,
    EasyDialogsAnimationType animationType = EasyDialogsAnimationType.slide,
    bool autoHide = false,
    Color? backgroundColor,
  }) async {
    for (var dialog in _currentBanners) {
      await dialog.dismiss();
    }
    _overlayState.removeEntriesByType(EasyDialogType.banner);

    late final IDialogControlPanel bannerControlPanel;

    final banner = _easyDialogsFactory.createBanner(
      data: const EasyDialogsAnimatableData(
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 200),
        reverseDuration: Duration(milliseconds: 300),
      ),
      backgroundColor: backgroundColor,
      onControlPanelCreated: (controlPanel) {
        bannerControlPanel = controlPanel;
        _currentBanners.add(bannerControlPanel);
      },
      animationType: animationType,
      position: position,
      content: content,
    );

    final overlay = EasyDialogsOverlayEntry(
      type: EasyDialogType.banner,
      builder: (context) => banner,
    );
    _overlayState.insert(overlay);

    if (!autoHide) return;

    Future.delayed(
      _theme.modalBannerDuration,
      () async {
        await bannerControlPanel.dismiss();

        if (!overlay.mounted) return;

        overlay.remove();
        _currentBanners.remove(bannerControlPanel);
      },
    );
  }
}
