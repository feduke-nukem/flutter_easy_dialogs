import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_overlay_app_entry.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay.dart';
import 'package:flutter_test/flutter_test.dart';

final _key = GlobalKey<EasyDialogsOverlayState>();

EasyDialogsOverlayState get easyOverlayState => _key.currentState!;

const dialogKey = ValueKey('dialog');

const testCurve = Curves.linear;

Widget app({
  EasyDialogSetupManagers? setupManagers,
  Widget? child,
}) =>
    MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Material(
          child: EasyDialogsOverlay(
            key: _key,
            setupManagers: setupManagers,
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

AnimationController createTestController() => AnimationController(
      vsync: const TestVSync(),
    );
