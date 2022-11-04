import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class EasyOverlayEntry extends EasyDialogsOverlayEntryBase {
  EasyOverlayEntry({
    required super.builder,
  });
}

class EasyOverlayAppEntry extends EasyDialogsOverlayEntryBase {
  EasyOverlayAppEntry({
    required super.builder,
  });
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
