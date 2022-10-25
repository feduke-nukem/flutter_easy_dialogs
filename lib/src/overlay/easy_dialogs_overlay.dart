import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/agents/banner_agent/banner_agent.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_orverlay_entry_properties.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_controller.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialog_type.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay_entry.dart';
import 'package:flutter_easy_dialogs/src/utils/position_to_animation_converter.dart';
import 'package:flutter_easy_dialogs/src/widgets/easy_dialogs/easy_dialogs_theme.dart';

class EasyDialogsOverlay extends Overlay {
  const EasyDialogsOverlay({
    super.initialEntries = const <OverlayEntry>[],
    super.clipBehavior = Clip.hardEdge,
    super.key,
  });

  @override
  OverlayState createState() => _EasyDialogsOverlayState();
}

class _EasyDialogsOverlayState extends OverlayState
    implements IEasyDialogsOverlayController {
  final _currentEntries = <EasyDialogOverlayEntryProperties, OverlayEntry>{};
  late final EasyDialogsController _easyDialogsController;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Map<EasyDialogOverlayEntryProperties, OverlayEntry>>(
        'currentEntries',
        _currentEntries,
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
    final theme = EasyDialogsTheme.of(context);
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
  void insertDialog({
    required Widget child,
    required EasyDialogPosition position,
    required EasyDialogType type,
  }) {
    final props = EasyDialogOverlayEntryProperties(
      dialogPosition: position,
      dialogType: type,
    );

    final entry = EasyDialogsOverlayEntry(
      properties: props,
      builder: (_) => child,
    );

    insert(entry);
  }

  @override
  void insert(
    OverlayEntry entry, {
    OverlayEntry? below,
    OverlayEntry? above,
  }) {
    super.insert(entry, below: below, above: above);
    _handleNewEntry(entry);

    if (below != null) _handleNewEntry(below);
    if (above != null) _handleNewEntry(above);
  }

  @override
  void insertAll(
    Iterable<OverlayEntry> entries, {
    OverlayEntry? below,
    OverlayEntry? above,
  }) {
    super.insertAll(entries, below: below, above: above);

    entries.forEach(_handleNewEntry);

    if (below != null) _handleNewEntry(below);
    if (above != null) _handleNewEntry(above);
  }

  @override
  void removeDialogByTypeAndPosition({
    required EasyDialogType type,
    required EasyDialogPosition position,
  }) {
    if (_currentEntries.entries.isEmpty) return;

    final entry = _currentEntries.remove(
      EasyDialogOverlayEntryProperties(
        dialogPosition: position,
        dialogType: type,
      ),
    );

    if (entry == null || !entry.mounted) return;

    entry.remove();
  }

  void _handleNewEntry(OverlayEntry entry) {
    final newOverlayEntryProps = (entry is EasyDialogsOverlayEntry)
        ? entry.properties
        : EasyDialogOverlayEntryProperties.other();

    if (newOverlayEntryProps.dialogType == EasyDialogType.app) {
      assert(
        !_currentEntries.keys
            .any((props) => props.dialogType == EasyDialogType.app),
        'Only one app $EasyDialogsOverlay can be presented at the same time',
      );
    }

    assert(
      !_currentEntries.containsKey(newOverlayEntryProps),
      'only single one $EasyDialogType with the same $EasyDialogPosition can be presented at the same time',
    );

    assert(
      !_currentEntries.keys
          .any((props) => props.dialogType == EasyDialogPosition.other),
      'Only single one $EasyDialogType of "other" can be presented at the same time',
    );

    _currentEntries[newOverlayEntryProps] = entry;
  }

  void _init() {
    final positionToAnimationConverter = PositionToAnimationConverter();

    final bannerAgent = BannerAgent(
      positionToAnimationConverter: positionToAnimationConverter,
      overlayController: this,
    );

    _easyDialogsController = EasyDialogsController(
      bannerAgent: bannerAgent,
    );
  }
}

/// Interface for manipulating overlay with dialogs
abstract class IEasyDialogsOverlayController extends TickerProvider {
  void insertDialog({
    required Widget child,
    required EasyDialogPosition position,
    required EasyDialogType type,
  });

  void removeDialogByTypeAndPosition({
    required EasyDialogType type,
    required EasyDialogPosition position,
  });
}
