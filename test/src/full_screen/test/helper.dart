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

class FooManager extends EasyDialogController {
  FooManager({required super.overlayController});

  @override
  Future<void> hide({required EasyDialogManagerHideParams? options}) async {}

  @override
  Future<void> show({required EasyDialog? dialog}) async {}
}

class BarManager extends EasyDialogController {
  BarManager({required super.overlayController});

  @override
  Future<void> hide({required EasyDialogManagerHideParams? options}) async {}

  @override
  Future<void> show({required EasyDialog? dialog}) async {}
}

AnimationController createTestController() => AnimationController(
      vsync: const TestVSync(),
      duration: Duration.zero,
    );
