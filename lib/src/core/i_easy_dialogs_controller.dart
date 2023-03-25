import 'dart:async';

import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

/// Controller for manipulating dialogs via [FlutterEasyDialogs].
abstract class IEasyDialogsController {
  /// Show positioned dialog.
  Future<void> showPositioned({required PositionedShowParams params});

  /// Hide positioned dialog.
  Future<void> hidePositioned({required EasyDialogPosition position});

  /// Hide all positioned dialogs.
  Future<void> hideAllPositioned();

  Future<void> showFullScreen({required FullScreenShowParams params});

  /// Hide full screen dialog.
  Future<void> hideFullScreen();

  /// Get your [CustomDialogManager] and use it.
  T useCustom<T extends CustomDialogManager>();
}
