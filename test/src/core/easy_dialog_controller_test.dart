import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper.dart';

void main() {
  group('easy dialog controller', () {
    testWidgets('show different dialogs. entries correctly reflect',
        (widgetTester) async {
      await widgetTester.pumpWidget(app());

      final controller = easyOverlayState.controller;

      controller.show(
        EasyDialog.positioned(
          content: Container(),
          autoHideDuration: null,
        ),
      );
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));
      controller.show(
        EasyDialog.positioned(
          content: Container(),
          position: EasyDialogPosition.bottom,
          autoHideDuration: null,
        ),
      );

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      expect(
        controller.entries.values.every(
          (element) => element.dialog is PositionedDialog,
        ),
        isTrue,
      );
      expect(controller.entries.length, equals(2));

      controller.show(
        EasyDialog.fullScreen(
          content: Container(),
          decoration: FullScreenShell.modalBanner(),
        ),
      );

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      expect(controller.entries.length, equals(3));
      expect(controller.entries.values.last.dialog, isA<FullScreenDialog>());
    });

    testWidgets('show different and hide where type', (widgetTester) async {
      await widgetTester.pumpWidget(app());

      final controller = easyOverlayState.controller;

      controller.show(
        EasyDialog.positioned(
          content: Container(),
          autoHideDuration: null,
        ),
      );
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));
      controller.show(
        EasyDialog.positioned(
          content: Container(),
          position: EasyDialogPosition.bottom,
          autoHideDuration: null,
        ),
      );

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      controller.show(FullScreenDialog(content: Container()));

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      controller.hideWhere<PositionedDialog>((_) => true);

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      expect(controller.entries.length, equals(1));
      expect(controller.entries.values.first.dialog, isA<FullScreenDialog>());
    });

    testWidgets('show different and hide where', (widgetTester) async {
      await widgetTester.pumpWidget(app());

      final controller = easyOverlayState.controller;

      controller.show(
        EasyDialog.positioned(
          content: Container(),
          autoHideDuration: null,
        ),
      );
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));
      controller.show(
        EasyDialog.positioned(
          content: Container(),
          position: EasyDialogPosition.bottom,
          autoHideDuration: null,
        ),
      );

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      controller.show(
        EasyDialog.fullScreen(content: Container()),
      );

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      controller.hideWhere<PositionedDialog>(
        (element) => element.position == EasyDialogPosition.bottom,
      );

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      expect(controller.entries.length, equals(2));
      expect(controller.entries.values.first.dialog, isA<PositionedDialog>());
      expect(
        (controller.entries.values.first.dialog as PositionedDialog).position,
        EasyDialogPosition.top,
      );
      expect(controller.entries.values.last.dialog, isA<FullScreenDialog>());
    });

    testWidgets('show three positions and hide two of them',
        (widgetTester) async {
      await widgetTester.pumpWidget(app());

      final controller = easyOverlayState.controller;
      final topDialog = EasyDialog.positioned(
        content: Container(),
        autoHideDuration: null,
      );

      expect(() => controller.hide(id: topDialog.id), throwsAssertionError);
      expect(controller.isShown(id: topDialog.id), isFalse);
      expect(() => controller.get(topDialog.id), throwsA(isA<FlutterError>()));

      controller.show(topDialog);
      final bottomDialog = EasyDialog.positioned(
        content: Container(),
        position: EasyDialogPosition.bottom,
        autoHideDuration: null,
      );
      controller.show(bottomDialog);

      final centerDialog = EasyDialog.positioned(
        content: Container(),
        position: EasyDialogPosition.center,
        autoHideDuration: null,
      );
      controller.show(centerDialog);
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      expect(controller.isShown(id: topDialog.id), isTrue);
      expect(() => controller.get(topDialog.id), returnsNormally);

      controller.hideWhere<PositionedDialog>(
        (element) =>
            element.position == EasyDialogPosition.bottom ||
            element.position == EasyDialogPosition.center,
      );

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      expect(topDialog.state, EasyDialogLifecycleState.shown);
      expect(bottomDialog.state, EasyDialogLifecycleState.disposed);
      expect(centerDialog.state, EasyDialogLifecycleState.disposed);
    });

    testWidgets('show dialog with decoration and get decoration of exact type ',
        (widgetTester) async {
      await widgetTester.pumpWidget(
        app(),
      );

      final controller = easyOverlayState.controller;
      final dialog = EasyDialog.positioned(
        content: Container(),
        autoHideDuration: null,
        decoration: EasyDialogDismiss.tap().chained(
          _TestDecoration(),
        ),
      );

      controller.show(dialog);

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      expect(
        dialog.context.getDecorationOfExactType<EasyDialogDismiss>(),
        isA<EasyDialogDismiss>(),
      );

      expect(
        EasyDialogDecoration.of<_TestDecoration>(dialog.context),
        isNotNull,
      );
    });

    testWidgets('show dialog and dismiss with result', (widgetTester) async {
      await widgetTester.pumpWidget(app());

      int? result;
      final controller = easyOverlayState.controller;
      final dialog = EasyDialog.positioned(
        content: Container(
          height: 300.0,
          width: double.infinity,
          color: Colors.red,
          key: dialogKey,
        ),
        autoHideDuration: null,
        decoration: EasyDialogDismiss.tap(
          onDismissed: () => 0,
        ),
      );

      controller.show<int>(dialog).then((value) => result = value);

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      final content = find.byKey(dialogKey);

      await widgetTester.tap(content);

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      expect(result, isNotNull);
      expect(result, equals(0));
    });

    testWidgets('show dialog that was shown => assertion error',
        (widgetTester) async {
      await widgetTester.pumpWidget(
        app(),
      );

      final controller = easyOverlayState.controller;
      final dialog = EasyDialog.positioned(
        content: Container(),
      );

      controller.show(dialog);

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      controller.hide(id: dialog.id);

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      expect(
        () => controller.show(dialog),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('show multiple dismiss and find parent for child',
        (widgetTester) async {
      await widgetTester.pumpWidget(
        app(),
      );

      int? result;
      final controller = easyOverlayState.controller;
      final parent = EasyDialogDismiss<PositionedDialog>.tap(
        onDismissed: () => 0,
      );
      final child = EasyDialogDismiss<PositionedDialog>.swipe();
      final decoration = PositionedShell.banner().combined([
        parent,
        EasyDialogAnimation<PositionedDialog>.fade().chained(
          EasyDialogAnimation.fade(),
        ),
        EasyDialogDecoration.builder(
          (context, dialog) => Padding(
            padding: EdgeInsets.all(10),
            child: dialog.content,
          ),
        ),
        _TestDecoration(),
        child,
      ]);

      final dialog = EasyDialog.positioned(
        content: Container(
          height: 300.0,
          width: double.infinity,
          color: Colors.red,
          key: dialogKey,
        ),
        autoHideDuration: null,
        decoration: decoration,
      );

      controller.show<int>(dialog).then((value) => result = value);

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      final foundParent =
          dialog.context.getParentDecorationOfType<EasyDialogDismiss>(child);

      expect(foundParent, isA<EasyDialogDismiss>());

      final content = find.byKey(dialogKey);

      expect(
        EasyDialogDecoration.maybeOf<_TestDecoration>(dialog.context),
        isNotNull,
      );

      await widgetTester.drag(content, const Offset(500, 0));

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      // derived from parent (tap) dismiss callback to child (swipe)
      // even if the callback wasn't passed to the child directly.
      expect(result, isNotNull);
      expect(result, equals(0));
    });
    testWidgets('show and hide via extension', (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          builder: FlutterEasyDialogs.builder(),
        ),
      );

      int? result;

      final dialog = EasyDialog.positioned(
        content: Container(
          height: 300.0,
          width: double.infinity,
          color: Colors.red,
          key: dialogKey,
        ),
        autoHideDuration: null,
      )..show<int>().then((value) => result = value);

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      final content = find.byKey(dialogKey);

      expect(content, findsOneWidget);
      expect(dialog.state, EasyDialogLifecycleState.shown);
      dialog.hide(result: 0);

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      expect(result, isNotNull);
      expect(result, equals(0));
    });
    testWidgets('show dialog and use vsync of context', (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          builder: FlutterEasyDialogs.builder(),
        ),
      );

      final dialog = EasyDialog.positioned(
        content: Container(),
        autoHideDuration: null,
        decoration: EasyDialogDecoration.none(),
      )..show();

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      expect(
        () => AnimationController(vsync: dialog.context.vsync),
        returnsNormally,
      );
    });
    testWidgets(
        'show dialog with decoration builder and all callbacks fire correctly',
        (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          builder: FlutterEasyDialogs.builder(),
        ),
      );

      bool didInit = false;
      bool didShow = false;
      bool didShowed = false;
      bool didHide = false;
      bool didHided = false;
      bool didDispose = false;

      final dialog = EasyDialog.positioned(
        content: Container(),
        autoHideDuration: null,
        decoration: EasyDialogDecoration.builder(
          onDispose: () => didDispose = true,
          onInit: () => didInit = true,
          onShow: () => didShow = true,
          onShown: () => didShowed = true,
          onHide: () => didHide = true,
          onHidden: () => didHided = true,
          (context, dialog) => SizedBox(
            child: dialog.content,
          ),
        ),
      )..show();

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));
      dialog.hide();
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      expect(didInit, isTrue);
      expect(didShow, isTrue);
      expect(didShowed, isTrue);
      expect(didHide, isTrue);
      expect(didHided, isTrue);
      expect(didDispose, isTrue);
    });

    testWidgets(
      'show the dialog with the same identity, previous hid => new shown',
      (widgetTester) async {
        await widgetTester.pumpWidget(app());
        const firsKey = Key('first');
        const secondKey = Key('second');

        final controller = easyOverlayState.controller;

        controller.show(
          EasyDialog.positioned(
            id: 'id',
            content: Container(
              color: Colors.red,
              height: 300,
              width: 300,
              key: firsKey,
            ),
            autoHideDuration: null,
            decoration: EasyDialogDecoration.none(),
          ),
        );

        await widgetTester.pumpAndSettle(const Duration(seconds: 3));

        expect(find.byKey(firsKey), findsOneWidget);

        controller.show(
          EasyDialog.positioned(
            id: 'id',
            content: Container(
              color: Colors.black12,
              height: 300,
              width: 300,
              key: secondKey,
            ),
            autoHideDuration: null,
            decoration: EasyDialogDecoration.none(),
          ),
        );
        await widgetTester.pumpAndSettle(const Duration(seconds: 3));

        expect(find.byKey(firsKey), findsNothing);
        expect(find.byKey(secondKey), findsOneWidget);
        expect(controller.entries.length, 1);
      },
    );

    Future<void> showAndHideWithAllExtensions(
        EasyDialog Function(Widget content) dialogBuilder,
        WidgetTester widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          builder: FlutterEasyDialogs.builder(),
        ),
      );
      const firsKey = Key('first');

      final dialog = dialogBuilder(Container(
        color: Colors.red,
        height: 300,
        width: 300,
        key: firsKey,
      ))
          .fade()
          .expansion()
          .animatedTap()
          .draggable()
          .fadeBackground()
          .blurBackground()
          .tap()
          .swipe()
          .slideHorizontal()
          .slideVertical()
          .bounce();

      dialog.show();
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byKey(firsKey), findsOneWidget);

      dialog.hide();
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));
    }

    testWidgets(
      'show the positioned dialog with all extensions',
      (widgetTester) async {
        await showAndHideWithAllExtensions(
          (content) => content.positioned(
            autoHideDuration: null,
          ),
          widgetTester,
        );
      },
    );
    testWidgets(
      'show the positioned dialog with all extensions',
      (widgetTester) async {
        await showAndHideWithAllExtensions(
          (content) => content.fullScreen(),
          widgetTester,
        );
      },
    );
  });
}

final class _TestDecoration extends EasyDialogDecoration<PositionedDialog> {
  @override
  Widget call(PositionedDialog dialog) {
    return SizedBox(
      child: dialog.content,
    );
  }
}
