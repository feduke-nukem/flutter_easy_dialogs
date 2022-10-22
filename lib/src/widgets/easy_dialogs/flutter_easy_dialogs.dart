import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_controller.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialog_type.dart';
import 'package:flutter_easy_dialogs/src/widgets/easy_dialogs/easy_dialogs_overlay.dart';

import 'easy_dialogs_theme.dart';

/// Service - helper for easy use different custom dialogs
class FlutterEasyDialogs extends StatelessWidget {
  /// Theme of [FlutterEasyDialogs]
  final EasyDialogsThemeData? theme;

  /// Child widget
  final Widget child;

  /// Creates instance of [FlutterEasyDialogs]
  const FlutterEasyDialogs({
    required this.child,
    this.theme,
    super.key,
  });

  /// Provides access to [_EasyDialogsShellState] for dialogs' control
  static EasyDialogsController of(
    BuildContext context,
  ) {
    final scope = context
        .getElementForInheritedWidgetOfExactType<_EasyDialogsScope>()!
        .widget as _EasyDialogsScope;

    return scope.controller;
  }

  /// For using in [MaterialApp.builder]
  static const builder = _builder;

  static TransitionBuilder _builder({
    EasyDialogsThemeData? theme,
  }) {
    return (context, child) => FlutterEasyDialogs(
          theme: theme,
          child: child ?? const SizedBox.shrink(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return EasyDialogsTheme(
      data: theme ?? EasyDialogsThemeData.basic(),
      child: _EasyDialogsShell(
        child: child,
      ),
    );
  }
}

/// [FlutterEasyDialogs] shell widget
/// Provides some data into [EasyDialogsController] and wraps it's child into
/// helper - widgets like [Overlay]
class _EasyDialogsShell extends StatefulWidget {
  /// Child widget
  final Widget child;

  /// Creates instance of [_EasyDialogsShell]
  const _EasyDialogsShell({
    required this.child,
  });

  @override
  State<_EasyDialogsShell> createState() => _EasyDialogsShellState();
}

class _EasyDialogsShellState extends State<_EasyDialogsShell>
    with TickerProviderStateMixin {
  /// Data of [DialogTheme]
  late EasyDialogsThemeData theme;

  /// Instance of [EasyDialogsController]
  late final _controller = EasyDialogsController(
    theme: theme,
  );

  @override
  void didChangeDependencies() {
    theme = EasyDialogsTheme.of(context);
    _controller.updateTheme(theme);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _EasyDialogsScope(
      controller: _controller,
      child: Material(
        child: EasyDialogsOverlay(
          key: _controller.overlayKey,
          initialEntries: [
            EasyDialogsOverlayEntry(
              type: EasyDialogType.main,
              builder: (context) => widget.child,
            ),
          ],
        ),
      ),
    );
  }
}

/// Inherited scope for providing [EasyDialogsController]
class _EasyDialogsScope extends InheritedWidget {
  /// Instance of [EasyDialogsController]
  final EasyDialogsController controller;

  /// Creates instance of [_EasyDialogsScope]
  const _EasyDialogsScope({
    required super.child,
    required this.controller,
  });

  @override
  bool updateShouldNotify(_EasyDialogsScope oldWidget) {
    return controller != oldWidget.controller;
  }
}
