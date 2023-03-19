import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/positioned/easy_dialog_position.dart';
import 'package:flutter_easy_dialogs/src/positioned/manager/positioned_show_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../../helper.dart';

final _bannerContent = ElevatedButton(
  key: dialogKey,
  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
  onPressed: () {},
  child: const Text(
    'BANNER',
    style: TextStyle(fontSize: 30),
  ),
);

void main() {
  testGoldens('show at top', (tester) async {
    await tester.pumpWidget(app());

    unawaited(
      easyOverlayState.easyDialogsController.showPositioned(
        params: PositionedShowParams(content: _bannerContent),
      ),
    );

    await tester.pump();

    expect(find.byKey(dialogKey), findsOneWidget);
    await multiScreenGolden(tester, 'easy_banner_multi_screen_positioned_top');
  });

  testGoldens('show at bottom', (tester) async {
    await tester.pumpWidget(app());

    unawaited(
      easyOverlayState.easyDialogsController.showPositioned(
        params: PositionedShowParams(
          content: _bannerContent,
          position: EasyDialogPosition.bottom,
        ),
      ),
    );

    await tester.pump();

    expect(find.byKey(dialogKey), findsOneWidget);
    await multiScreenGolden(
      tester,
      'easy_banner_multi_screen_positioned_bottom',
    );
  });

  testGoldens('show postponed at center', (tester) async {
    await tester.pumpWidget(app());

    unawaited(
      easyOverlayState.easyDialogsController.showPositioned(
          params: PositionedShowParams(
        content: _bannerContent,
        position: EasyDialogPosition.center,
      )),
    );

    await tester.pump();

    expect(find.byKey(dialogKey), findsOneWidget);
    await multiScreenGolden(
      tester,
      'multi_screen_positioned_center',
    );
  });
}
