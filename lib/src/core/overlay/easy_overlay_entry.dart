import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Simple overlay entry
class EasyOverlayEntry extends EasyDialogsOverlayEntryBase {
  /// Creates an instance of [EasyOverlayEntry]
  EasyOverlayEntry({
    required super.builder,
  });
}

/// App overlay entry
class EasyOverlayAppEntry extends EasyDialogsOverlayEntryBase {
  /// Creates an instance of [EasyOverlayAppEntry]
  EasyOverlayAppEntry({
    required super.builder,
  });
}

/// Core class of extended [OverlayEntry]
abstract class EasyDialogsOverlayEntryBase extends OverlayEntry {
  /// Creates an instance of [EasyDialogsOverlayEntryBase]
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
