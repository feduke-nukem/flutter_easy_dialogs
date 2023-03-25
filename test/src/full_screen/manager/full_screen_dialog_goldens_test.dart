import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/full_screen/manager/full_screen_dialog_manager.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../../helper.dart';

final _content = Container(
  height: 200,
  width: 200,
  color: Colors.blue,
  alignment: Alignment.center,
  child: Text(
    'Full screen dialog',
    textAlign: TextAlign.center,
  ),
);

void main() {
  testGoldens('show', (tester) async {
    await tester.pumpWidget(app());

    unawaited(
      easyOverlayState.easyDialogsController
          .showFullScreen(params: FullScreenShowParams(content: _content)),
    );

    await tester.pump();

    await multiScreenGolden(tester, 'show_multi_screen');
  });

  testGoldens('show and hide', (tester) async {
    await tester.pumpWidget(app());

    unawaited(
      easyOverlayState.easyDialogsController
          .showFullScreen(params: FullScreenShowParams(content: _content)),
    );

    await tester.pumpAndSettle();

    unawaited(easyOverlayState.easyDialogsController.hideFullScreen());

    await tester.pumpAndSettle();

    await multiScreenGolden(tester, 'show_and_hide_multi_screen');
  });
}
