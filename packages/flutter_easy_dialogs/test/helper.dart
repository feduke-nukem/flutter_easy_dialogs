import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_overlay_app_entry.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay.dart';
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

class FooManager extends EasyDialogManager {
  FooManager({required super.overlayController});

  @override
  Future<void> hide({required EasyDialogManagerHideParams? params}) async {}

  @override
  Future<void> show({required EasyDialogManagerShowParams? params}) async {}
}

class BarManager extends EasyDialogManager {
  BarManager({required super.overlayController});

  @override
  Future<void> hide({required EasyDialogManagerHideParams? params}) async {}

  @override
  Future<void> show({required EasyDialogManagerShowParams? params}) async {}
}

class TestDialogManager extends EasyDialogManager<EasyDialogManagerShowParams,
    EasyDialogManagerHideParams?> {
  TestDialogManager({required super.overlayController});

  int? _id;

  @override
  Future<void> hide({EasyDialogManagerHideParams? params}) async => _hide();

  void _hide() => super
      .overlayController
      .removeDialog(BasicDialogRemoveStrategy(dialogId: _id!));

  @override
  Future<void> show({required EasyDialogManagerShowParams params}) async {
    if (_id != null) _hide();

    super.overlayController.insertDialog(
          BasicDialogInsertStrategy(
            dialog: params.content,
            onInserted: (dialogId) => _id = dialogId,
          ),
        );
  }
}

AnimationController createTestController() => AnimationController(
      vsync: const TestVSync(),
    );
