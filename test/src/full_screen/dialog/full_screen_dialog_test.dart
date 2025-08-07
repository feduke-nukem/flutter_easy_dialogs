import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

final _content = Container(
  key: dialogKey,
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
  group('full screen dialog', () {
    testWidgets('show and hide', (widgetTester) async {
      await widgetTester.pumpWidget(app());

      easyOverlayState.controller.show(
        EasyDialog.fullScreen(content: _content),
      );

      await widgetTester.pumpAndSettle();

      expect(find.byKey(dialogKey), findsOneWidget);

      expect(easyOverlayState.box.currentEntries.isNotEmpty, isTrue);
      expect(
        easyOverlayState.box.get(FullScreenDialog.defaultId),
        isA<EasyDialogsOverlayEntry>(),
      );

      easyOverlayState.controller.hide(id: FullScreenDialog.defaultId);

      await widgetTester.pumpAndSettle();

      expect(find.byKey(dialogKey), findsNothing);

      expect(easyOverlayState.box.currentEntries.isEmpty, isTrue);
      expect(easyOverlayState.box.get(FullScreenDialog.defaultId), isNull);
    });

    testWidgets('show one, then show another', (widgetTester) async {
      await widgetTester.pumpWidget(
        app(),
      );

      easyOverlayState.controller.show(
        EasyDialog.fullScreen(content: _content),
      );

      await widgetTester.pumpAndSettle();

      easyOverlayState.controller.show(
        EasyDialog.fullScreen(
          content: Container(
            key: const Key('value'),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      expect(find.byKey(dialogKey), findsNothing);
      expect(find.byKey(const Key('value')), findsOneWidget);

      expect(easyOverlayState.box.currentEntries.isNotEmpty, isTrue);
      expect(easyOverlayState.box.get(FullScreenDialog.defaultId), isNotNull);
    });
  });

  test('clone', () {
    const id = 'id';
    final dialog = FullScreenDialog(
      content: const SizedBox.shrink(),
      id: id,
      androidWillPop: () => false,
      animationConfiguration: EasyDialogAnimationConfiguration.bounded(
        startValue: 0.0,
        lowerBound: 0.0,
        upperBound: 1.0,
      ),
      autoHideDuration: Duration(seconds: 1),
      decoration: EasyDialogAnimation.bounce(),
    );
    final cloned = dialog.clone() as FullScreenDialog;

    expect(cloned.id, id);
    expect(cloned.content, dialog.content);
    expect(cloned.androidWillPop, dialog.androidWillPop);
    expect(cloned.animationConfiguration, dialog.animationConfiguration);
    expect(cloned.autoHideDuration, dialog.autoHideDuration);
    expect(cloned.decoration, dialog.decoration);
  });

  test('create with id', () {
    const id = 'id';
    final dialog = FullScreenDialog(
      content: const SizedBox.shrink(),
      id: id,
    );

    expect(dialog.id, id);
  });

  test('create without id', () {
    final dialog = FullScreenDialog(
      content: const SizedBox.shrink(),
    );

    expect(dialog.id, FullScreenDialog.defaultId);
  });
}
