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

part 'easy_overlay_insert_strategy.dart';
part 'easy_overlay_remove_strategy.dart';
part 'keys.dart';

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
  EasyOverlayState createState() => EasyOverlayState();
}

class EasyOverlayState extends OverlayState implements IEasyOverlayController {
  @visibleForTesting
  final currentEntries = <Object?, Object?>{};

  OverlayEntry? _appEntry;

  @override
  EasyOverlay get widget => super.widget as EasyOverlay;

  late final EasyDialogsController easyDialogsController;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<Map<Object?, Object?>>(
          '_currentEntries',
          currentEntries,
        ),
      )
      ..add(
        DiagnosticsProperty<OverlayEntry?>('appEntry', _appEntry),
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
    easyDialogsController.updateTheme(theme);

    super.didChangeDependencies();
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

  void _init() {
    final positionToAnimationConverter = PositionToAnimationConverter();
    final positionedAnimationFactory =
        PositionedAnimationFactory(positionToAnimationConverter);

    final positionedDismissibleFactory = PositionedDismissibleFactory();
    final modalBannerFactory = EasyModalBannerFactory();

    final bannerManager = PositionedDialogManager(
      overlayController: this,
      dialogFactory: EasyBannerFactory(
        animationFactory: positionedAnimationFactory,
        dismissibleFactory: positionedDismissibleFactory,
      ),
    );

    final modalBannerManager = FullScreenDialogManager(
      overlayController: this,
      dialogFactory: modalBannerFactory,
    );
    final customManagersRaw = widget.customManagersBuilder?.call(this);

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

    easyDialogsController = EasyDialogsController(
      bannerManager: bannerManager,
      modalBannerManager: modalBannerManager,
      customManagers: Map.fromIterable(
        customManagers,
        key: (customAgent) => customAgent.runtimeType,
      ),
    );
  }

  @override
  void insertDialog(EasyOverlayInsertStrategy strategy) => strategy.apply(this);

  @override
  void removeDialog(EasyOverlayRemoveStrategy strategy) => strategy.apply(this);
}

/// Interface for manipulating overlay with dialogs
abstract class IEasyOverlayController extends TickerProvider {
  void insertDialog(EasyOverlayInsertStrategy strategy);

  void removeDialog(EasyOverlayRemoveStrategy strategy);
}
