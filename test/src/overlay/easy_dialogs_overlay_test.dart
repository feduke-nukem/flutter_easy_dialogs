import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_overlay_app_entry.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper.dart';

void main() {
  testWidgets('insert two app entries', (widgetTester) async {
    await widgetTester.pumpWidget(
      app(),
    );

    expect(easyOverlayState.box.appEntry, isNull);
    expect(
      () => easyOverlayState
          .insertDialog(EasyOverlayAppEntry(builder: (_) => Container())),
      returnsNormally,
    );

    expect(easyOverlayState.box.appEntry, isNotNull);

    expect(
      () => easyOverlayState
          .insertDialog(EasyOverlayAppEntry(builder: (_) => Container())),
      throwsAssertionError,
    );

    expect(
        () =>
            easyOverlayState.debugFillProperties(DiagnosticPropertiesBuilder()),
        returnsNormally);
  });
}
