import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/easy_dialog_position.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/easy_dialog_type.dart';
import 'package:flutter_easy_dialogs/src/core/overlay/easy_orverlay_entry_properties.dart';

class EasyOverlayEntry extends EasyDialogsOverlayEntryBase {
  /// Dialog type
  final EasyOverlayEntryProperties properties;

  EasyOverlayEntry({
    required this.properties,
    required super.builder,
  });

  factory EasyOverlayEntry.app({
    required WidgetBuilder builder,
  }) {
    return EasyOverlayEntry(
      properties: const EasyOverlayEntryProperties(
        dialogPosition: EasyDialogPosition.center,
        dialogType: EasyDialogType.app,
      ),
      builder: builder,
    );
  }
}

abstract class EasyDialogsOverlayEntryBase extends OverlayEntry {
  EasyDialogsOverlayEntryBase({
    required super.builder,
  });

  @override
  void markNeedsBuild() {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        super.markNeedsBuild();
      });

      return;
    }

    super.markNeedsBuild();
  }
}
