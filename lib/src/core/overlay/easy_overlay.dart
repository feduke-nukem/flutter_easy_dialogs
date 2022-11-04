import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/agents/dialog_agent_base.dart';
import 'package:flutter_easy_dialogs/src/core/agents/fullscreen_dialog_agent/fullscreen_dialog_agent.dart';
import 'package:flutter_easy_dialogs/src/core/agents/positioned_dialog_agent.dart/positioned_dialog_agent.dart';
import 'package:flutter_easy_dialogs/src/core/animations/factory/positioned_animation_factory/positioned_animation_factory.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/easy_dialog_position.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/factory/easy_banner_factory.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/factory/easy_modal_banner_factory.dart';
import 'package:flutter_easy_dialogs/src/core/dismissibles/factory/positioned_dismissible_factory.dart';
import 'package:flutter_easy_dialogs/src/core/flutter_easy_dialogs/easy_dialog_scope.dart';
import 'package:flutter_easy_dialogs/src/core/flutter_easy_dialogs/easy_dialogs_controller.dart';
import 'package:flutter_easy_dialogs/src/core/flutter_easy_dialogs/flutter_easy_dialogs_theme.dart';
import 'package:flutter_easy_dialogs/src/core/overlay/overlay.dart';
import 'package:flutter_easy_dialogs/src/utils/position_to_animation_converter/position_to_animation_converter.dart';

typedef CustomAgentBuilder = Map<String, EasyDialogAgentBase> Function(
  IEasyOverlayController overlayController,
);

class EasyOverlay extends Overlay {
  final CustomAgentBuilder? customAgentBuilder;

  const EasyOverlay({
    super.initialEntries = const <OverlayEntry>[],
    super.clipBehavior = Clip.hardEdge,
    this.customAgentBuilder,
    super.key,
  });

  @override
  OverlayState createState() => _EasyOverlayState();
}

class _EasyOverlayState extends OverlayState implements IEasyOverlayController {
  final _currentPositionedEntries = <EasyDialogPosition, OverlayEntry>{};
  final _currentCustomEntries = <String, OverlayEntry>{};

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
  Widget build(BuildContext context) {
    return EasyDialogsScope(
      controller: _easyDialogsController,
      child: super.build(context),
    );
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
    if (_currentFullScreenEntry!.mounted) {
      _currentFullScreenEntry!.remove();
      _currentFullScreenEntry = null;
    }
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

    final bannerAgent = PositionedDialogAgent(
      overlayController: this,
      dialogFactory: EasyBannerFactory(
        animationFactory: positionedAnimationFactory,
        dismissibleFactory: positionedDismissibleFactory,
      ),
    );

    final modalBannerAgent = FullScreenDialogAgent(
      overlayController: this,
      dialogFactory: modalBannerFactory,
    );
    final customAgents = (widget as EasyOverlay).customAgentBuilder?.call(this);

    _easyDialogsController = EasyDialogsController(
      bannerAgent: bannerAgent,
      modalBannerAgent: modalBannerAgent,
      customAgents: customAgents,
    );
  }

  @override
  void insertCustomDialog({required String name, required Widget dialog}) {
    assert(
      !_currentCustomEntries.containsKey(name),
      'custom dialog with such $name already exists',
    );
    final entry = OverlayEntry(builder: (_) => dialog);
    _currentCustomEntries[name] = entry;

    insert(entry);
  }

  @override
  void removeCustomDialog({required String name}) {
    final entry = _currentCustomEntries.remove(name);

    if (entry == null || !entry.mounted) return;

    entry.remove();
  }
}

/// Interface for manipulating overlay with dialogs
abstract class IEasyOverlayController extends TickerProvider {
  void insertPositionedDialog({
    required Widget dialog,
    required EasyDialogPosition position,
  });

  void removePositionedDialog({
    required EasyDialogPosition position,
  });

  void insertFullScreenDialog({
    required Widget dialog,
  });

  void removeFullScreenDialog();

  void insertCustomDialog({
    required String name,
    required Widget dialog,
  });

  void removeCustomDialog({
    required String name,
  });
}
