import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_orverlay_entry_properties.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialog_type.dart';

class EasyDialogsOverlayEntry extends EasyDialogsOverlayEntryBase {
  /// Dialog type
  final EasyDialogOverlayEntryProperties properties;

  EasyDialogsOverlayEntry({
    required this.properties,
    required super.builder,
  });

  factory EasyDialogsOverlayEntry.app({
    required WidgetBuilder builder,
  }) {
    return EasyDialogsOverlayEntry(
      properties: const EasyDialogOverlayEntryProperties(
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
