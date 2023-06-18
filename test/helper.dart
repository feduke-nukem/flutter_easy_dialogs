import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_controller.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_overlay_app_entry.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_overlay.dart';
import 'package:flutter_test/flutter_test.dart';

final _key = GlobalKey<EasyDialogsOverlayState>();

EasyDialogsOverlayState get easyOverlayState => _key.currentState!;

const dialogKey = ValueKey('dialog');

Widget app({
  EasyDialogSetupManagers? managersSetup,
  Widget? child,
}) =>
    MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Material(
          child: EasyDialogsOverlay(
            key: _key,
            setupManagers: managersSetup,
            initialEntries: [
              EasyOverlayAppEntry(
                builder: (context) => child ?? const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
      home: child != null
          ? Builder(
              builder: (context) {
                return child;
              },
            )
          : null,
    );

final class FooManager extends EasyDialogsController {
  FooManager({required super.overlayController});

  @override
  Future<void> hide({required EasyDialogManagerHideParams? options}) async {}

  @override
  Future<void> show({required EasyDialog? dialog}) async {}
}

final class BarManager extends EasyDialogsController {
  BarManager({required super.overlayController});

  @override
  Future<void> hide({required EasyDialogManagerHideParams? options}) async {}

  @override
  Future<void> show({required EasyDialog? dialog}) async {}
}

final class TestDialogManager
    extends EasyDialogsController<EasyDialog, EasyDialogManagerHideParams?> {
  TestDialogManager({required super.overlayController});

  int? _id;

  @override
  Future<void> hide({EasyDialogManagerHideParams? options}) async => _hide();

  void _hide() => super.overlay.removeDialog(BasicDialogRemove(dialogId: _id!));

  @override
  Future<void> show({required EasyDialog dialog}) async {
    if (_id != null) _hide();

    super.overlay.insertDialog(
          BasicDialogInsert(
            dialog: dialog.child,
            onInserted: (dialogId) => _id = dialogId,
          ),
        );
  }
}

AnimationController createTestController() => AnimationController(
      vsync: const TestVSync(),
    );
