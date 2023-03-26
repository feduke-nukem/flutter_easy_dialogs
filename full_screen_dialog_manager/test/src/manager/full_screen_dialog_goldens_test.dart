import 'dart:async';

import 'package:flutter/material.dart';
import 'package:full_screen_dialog_manager/src/manager/full_screen_show_params.dart';
import 'package:full_screen_dialog_manager/src/util/full_screen_dialog_controller_x.dart';
import 'package:full_screen_dialog_manager/src/util/full_screen_manager_registrar_x.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../helper.dart';

final _content = Container(
  height: 200,
  width: 200,
  color: Colors.blue,
  alignment: Alignment.center,
  child: const Text(
    'Full screen dialog',
    textAlign: TextAlign.center,
  ),
);

void main() {
  testGoldens('show', (tester) async {
    await tester.pumpWidget(app(
      setupManagers: (overlayController, managerRegistrar) {
        managerRegistrar.registerFullScreen(overlayController);
      },
    ));

    unawaited(
      easyOverlayState.dialogManagerProvider
          .showFullScreen(FullScreenShowParams(content: _content)),
    );

    await tester.pump();

    await multiScreenGolden(tester, 'show_multi_screen');
  });

  testGoldens('show and hide', (tester) async {
    await tester.pumpWidget(app(
      setupManagers: (overlayController, managerRegistrar) {
        managerRegistrar.registerFullScreen(overlayController);
      },
    ));

    unawaited(
      easyOverlayState.dialogManagerProvider
          .showFullScreen(FullScreenShowParams(content: _content)),
    );

    await tester.pumpAndSettle();

    unawaited(easyOverlayState.dialogManagerProvider.hideFullScreen());

    await tester.pumpAndSettle();

    await multiScreenGolden(tester, 'show_and_hide_multi_screen');
  });
}
