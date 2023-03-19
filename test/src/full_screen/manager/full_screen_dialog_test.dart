import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/full_screen/dismissible/easy_full_screen_dismissible.dart';
import 'package:flutter_easy_dialogs/src/full_screen/manager/full_screen_manager.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay_entry.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

final _content = Container(
  key: dialogKey,
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
  testWidgets('show and hide', (widgetTester) async {
    await widgetTester.pumpWidget(app());

    easyOverlayState.easyDialogsController
        .showFullScreen(params: FullScreenShowParams(content: _content));

    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsOneWidget);

    expect(easyOverlayState.box.currentEntries.isNotEmpty, isTrue);
    expect(easyOverlayState.box.get(FullScreenManager),
        isA<EasyDialogsOverlayEntry>());

    easyOverlayState.easyDialogsController.hideFullScreen();

    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsNothing);

    expect(easyOverlayState.box.currentEntries.isEmpty, isTrue);
    expect(easyOverlayState.box.get(FullScreenManager), isNull);
  });

  testWidgets('show one, then show another', (widgetTester) async {
    await widgetTester.pumpWidget(app());

    easyOverlayState.easyDialogsController
        .showFullScreen(params: FullScreenShowParams(content: _content));

    await widgetTester.pumpAndSettle();

    easyOverlayState.easyDialogsController.showFullScreen(
      params: FullScreenShowParams(
        content: Container(
          key: Key('value'),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsNothing);
    expect(find.byKey(Key('value')), findsOneWidget);

    expect(easyOverlayState.box.currentEntries.isNotEmpty, isTrue);
    expect(easyOverlayState.box.get(FullScreenManager), isNotNull);
  });

  testWidgets('show and tap with gesture dismissible', (widgetTester) async {
    await widgetTester.pumpWidget(app());

    easyOverlayState.easyDialogsController.showFullScreen(
        params: FullScreenShowParams(
            content: _content,
            dismissible: EasyFullScreenDismissible.gesture(
              onDismiss: easyOverlayState.easyDialogsController.hideFullScreen,
            )));

    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsOneWidget);

    final finder = find.byKey(dialogKey);

    await widgetTester.tap(finder);

    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsNothing);
  });

  testWidgets('show and tap with none dismissible', (widgetTester) async {
    await widgetTester.pumpWidget(app());

    easyOverlayState.easyDialogsController.showFullScreen(
      params: FullScreenShowParams(
        content: _content,
        dismissible: EasyFullScreenDismissible.none(),
      ),
    );

    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsOneWidget);

    final finder = find.byKey(dialogKey);

    await widgetTester.tap(finder);

    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsOneWidget);
  });
}
