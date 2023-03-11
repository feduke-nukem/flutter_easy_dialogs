import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/animations/positioned/factory/positioned_animation_factory.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/easy_banner/easy_banner_factory.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/easy_dialog_position.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/easy_modal_banner/easy_modal_banner_factory.dart';
import 'package:flutter_easy_dialogs/src/core/dismissibles/factory/positioned_dismissible_factory.dart';
import 'package:flutter_easy_dialogs/src/core/flutter_easy_dialogs/easy_dialogs_controller.dart';
import 'package:flutter_easy_dialogs/src/core/flutter_easy_dialogs/flutter_easy_dialogs_theme.dart';
import 'package:flutter_easy_dialogs/src/core/managers/easy_dialog_manager_base.dart';
import 'package:flutter_easy_dialogs/src/core/managers/full_screen_dialog_manager/full_screen_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/core/managers/positioned_dialog_manager/positioned_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/core/overlay/overlay.dart';
import 'package:flutter_easy_dialogs/src/util/position_to_animation_converter/position_to_animation_converter.dart';

// Service - helper for easy use different custom dialogs
class FlutterEasyDialogs extends StatelessWidget {
  /// Theme of [FlutterEasyDialogs]
  final FlutterEasyDialogsThemeData? theme;

  final CustomManagerBuilder? customManagerBuilder;

  /// Child widget
  final Widget child;

  /// Creates an instance of [FlutterEasyDialogs]
  const FlutterEasyDialogs({
    required this.child,
    this.customManagerBuilder,
    this.theme,
    super.key,
  });

  static final _key = GlobalKey<_EasyOverlayState>();

  /// Gets [EasyDialogsController]
  static EasyDialogsController get dialogsController =>
      _key.currentState!._easyDialogsController;

  /// For using in [MaterialApp.builder]
  static const builder = _builder;

  static TransitionBuilder _builder({
    FlutterEasyDialogsThemeData? theme,
    CustomManagerBuilder? customManagerBuilder,
  }) {
    return (context, child) => FlutterEasyDialogs(
          theme: theme,
          customManagerBuilder: customManagerBuilder,
          child: child ?? const SizedBox.shrink(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyDialogsTheme(
      data: theme ?? FlutterEasyDialogsThemeData.basic(),
      child: Material(
        child: EasyOverlay(
          key: _key,
          customManagersBuilder: customManagerBuilder,
          initialEntries: [
            EasyOverlayAppEntry(
              builder: (context) => child,
            ),
          ],
        ),
      ),
    );
  }
}

/// Function for providing custom agents
typedef CustomManagerBuilder = List<EasyDialogManagerBase> Function(
  IEasyOverlayController overlayController,
);

/// Overlay for providing dialogs
class EasyOverlay extends Overlay {
  /// Custom agent builder function
  final CustomManagerBuilder? customManagersBuilder;

  /// Creates an instance of [EasyOverlay]
  const EasyOverlay({
    super.initialEntries = const <OverlayEntry>[],
    super.clipBehavior = Clip.hardEdge,
    this.customManagersBuilder,
    super.key,
  });

  @override
  OverlayState createState() => _EasyOverlayState();
}

class _EasyOverlayState extends OverlayState implements IEasyOverlayController {
  final _currentPositionedEntries = <EasyDialogPosition, OverlayEntry>{};
  final _currentCustomEntries = <OverlayEntry>[];

  OverlayEntry? _currentFullScreenEntry;
  OverlayEntry? _appEntry;

  late final EasyDialogsController _easyDialogsController;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<Map<EasyDialogPosition, OverlayEntry>>(
          'currentPositionedEntries',
          _currentPositionedEntries,
        ),
      )
      ..add(
        DiagnosticsProperty<OverlayEntry?>('appEntry', _appEntry),
      )
      ..add(
        DiagnosticsProperty<OverlayEntry?>(
          'currentFullScreenEntry',
          _currentFullScreenEntry,
        ),
      );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didChangeDependencies() {
    final theme = FlutterEasyDialogsTheme.of(context);
    _easyDialogsController.updateTheme(theme);

    super.didChangeDependencies();
  }

  @override
  void insertPositionedDialog({
    required Widget dialog,
    required EasyDialogPosition position,
  }) {
    assert(
      !_currentPositionedEntries.containsKey(position),
      'only single one $EasyOverlayEntry with the same $EasyDialogPosition can be presented at the same time',
    );

    final entry = EasyOverlayEntry(
      builder: (_) => dialog,
    );

    _currentPositionedEntries[position] = entry;

    insert(entry);
  }

  @override
  void insertFullScreenDialog({
    required Widget dialog,
  }) {
    assert(
      _currentFullScreenEntry == null,
      'only single one full screen $EasyOverlayEntry can be presented',
    );

    final entry = EasyOverlayEntry(
      builder: (_) => dialog,
    );

    insert(entry);

    _currentFullScreenEntry = entry;
  }

  @override
  void removeFullScreenDialog() {
    _currentFullScreenEntry!.remove();
    _currentFullScreenEntry = null;
  }

  @override
  void insert(
    OverlayEntry entry, {
    OverlayEntry? below,
    OverlayEntry? above,
  }) {
    if (entry is EasyOverlayAppEntry ||
        below is EasyOverlayAppEntry ||
        above is EasyOverlayAppEntry) {
      assert(
        _appEntry == null,
        'Only one $EasyOverlayAppEntry can be presented at the same time',
      );
    }

    super.insert(entry, below: below, above: above);
  }

  @override
  void removePositionedDialog({
    required EasyDialogPosition position,
  }) {
    if (_currentPositionedEntries.entries.isEmpty) return;

    final entry = _currentPositionedEntries.remove(position);

    if (entry == null || !entry.mounted) return;

    entry.remove();
  }

  void _init() {
    final positionToAnimationConverter = PositionToAnimationConverter();
    final positionedAnimationFactory =
        PositionedAnimationFactory(positionToAnimationConverter);

    final positionedDismissibleFactory = PositionedDismissibleFactory();
    final modalBannerFactory = EasyModalBannerFactory();

    final bannerAgent = PositionedDialogManager(
      overlayController: this,
      dialogFactory: EasyBannerFactory(
        animationFactory: positionedAnimationFactory,
        dismissibleFactory: positionedDismissibleFactory,
      ),
    );

    final modalBannerAgent = FullScreenDialogManager(
      overlayController: this,
      dialogFactory: modalBannerFactory,
    );
    final customManagersRaw =
        (widget as EasyOverlay).customManagersBuilder?.call(this);

    final customManagers = <EasyDialogManagerBase>[];

    if (customManagersRaw != null) {
      for (var customAgent in customManagersRaw) {
        assert(
          !customManagers.any(
            (agent) => agent.runtimeType == customAgent.runtimeType,
          ),
          'no duplicate type agents should be provided',
        );
        customManagers.add(customAgent);
      }
    }

    _easyDialogsController = EasyDialogsController(
      bannerManager: bannerAgent,
      modalBannerManager: modalBannerAgent,
      customManagers: Map.fromIterable(
        customManagers,
        key: (customAgent) => customAgent.runtimeType,
      ),
    );
  }

  @override
  int insertCustomDialog(Widget dialog) {
    final entry = OverlayEntry(builder: (_) => dialog);
    _currentCustomEntries.add(entry);
    insert(entry);

    return _currentCustomEntries.indexOf(entry);
  }

  @override
  void removeCustomDialog(int id) {
    final entry = ((id < _currentCustomEntries.length)
        ? _currentCustomEntries[id]
        : null);

    if (entry == null) return;

    _currentCustomEntries.removeAt(id);
    entry.remove();
  }
}

/// Interface for manipulating overlay with dialogs
abstract class IEasyOverlayController extends TickerProvider {
  /// Insert positioned dialog into overlay
  ///
  /// Only single one dialog of concrete position can persists at the same time
  void insertPositionedDialog({
    required Widget dialog,
    required EasyDialogPosition position,
  });

  /// Remove positioned dialog from overlay
  void removePositionedDialog({
    required EasyDialogPosition position,
  });

  /// Insert full screen dialog into overlay
  void insertFullScreenDialog({
    required Widget dialog,
  });

  /// Remove full screen dialog into overlay
  void removeFullScreenDialog();

  /// Insert custom dialog
  ///
  /// returns id of inserted [dialog]
  int insertCustomDialog(Widget dialog);

  /// Remove custom dialog using [id]
  void removeCustomDialog(int id);
}
