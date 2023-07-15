import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper.dart';

void main() {
  group('easy dialogs overlay', () {
    testWidgets('insert two app entries', (widgetTester) async {
      await widgetTester.pumpWidget(
        app(),
      );

      expect(easyOverlayState.box.appEntry, isNull);
      expect(
        () => easyOverlayState
            .insert(EasyOverlayAppEntry(builder: (_) => Container())),
        returnsNormally,
      );

      expect(easyOverlayState.box.appEntry, isNotNull);

      expect(
        () => easyOverlayState
            .insert(EasyOverlayAppEntry(builder: (_) => Container())),
        throwsAssertionError,
      );

      expect(
          () => easyOverlayState
              .debugFillProperties(DiagnosticPropertiesBuilder()),
          returnsNormally);
    });
  });
}
