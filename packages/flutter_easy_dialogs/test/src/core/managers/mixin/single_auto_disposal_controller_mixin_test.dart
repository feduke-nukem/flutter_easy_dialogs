import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helper.dart';
import '../../../../mock.dart';

class _DummyManager extends EasyDialogManager
    with SingleAutoDisposalControllerMixin {
  _DummyManager({required super.overlayController});

  int? _dialogId;

  @override
  Future<void> hide({EasyDialogManagerHideParams? params}) {
    return super
        .hideAndDispose(BasicDialogRemoveStrategy(dialogId: _dialogId!));
  }

  @override
  Future<void> show({EasyDialogManagerShowParams? params}) {
    return super.initializeAndShow(
      params,
      (animation) => BasicDialogInsertStrategy(
        dialog: const SizedBox(
          key: dialogKey,
        ),
        onInserted: (dialogId) => _dialogId = dialogId,
      ),
    );
  }

  @override
  AnimationController createAnimationController(
    TickerProvider vsync,
    EasyDialogManagerShowParams? params,
  ) =>
      AnimationController(
        vsync: const TestVSync(),
        duration: Duration.zero,
      );
}

void main() {
  test('create', () {
    expect(
      () => _DummyManager(overlayController: MockEasyOverlayController()),
      returnsNormally,
    );
  });

  testWidgets('show once', (widgetTester) async {
    await widgetTester.pumpWidget(
      app(
        managersSetup: (overlayController, dialogsRegistrar) {
          dialogsRegistrar.register(
              () => _DummyManager(overlayController: overlayController));
        },
      ),
    );

    final manager = easyOverlayState.dialogManagerProvider.use<_DummyManager>();

    expect(find.byKey(dialogKey), findsNothing);
    expect(manager.animationController, isNull);
    expect(() => manager.animation, throwsAssertionError);
    expect(manager.isPresented, isFalse);

    await manager.show();

    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsOneWidget);
    expect(manager.animationController, isNotNull);
    expect(manager.animationController!.isCompleted, isTrue);
    expect(manager.animation.value, 1.0);
    expect(manager.isPresented, isTrue);
  });

  testWidgets('show and hide', (widgetTester) async {
    await widgetTester.pumpWidget(
      app(
        managersSetup: (overlayController, dialogsRegistrar) {
          dialogsRegistrar.register(
              () => _DummyManager(overlayController: overlayController));
        },
      ),
    );

    final manager = easyOverlayState.dialogManagerProvider.use<_DummyManager>();

    await manager.show();

    await widgetTester.pump();

    expect(find.byKey(dialogKey), findsOneWidget);
    expect(manager.isPresented, isTrue);

    await manager.hide();

    await widgetTester.pump();
    expect(find.byKey(dialogKey), findsNothing);
    expect(manager.animationController, isNull);
    expect(() => manager.animation, throwsAssertionError);
    expect(manager.isPresented, isFalse);
  });

  testWidgets('initialize and show, hide and dispose', (widgetTester) async {
    await widgetTester.pumpWidget(
      app(
        managersSetup: (overlayController, dialogsRegistrar) {
          dialogsRegistrar.register(
              () => _DummyManager(overlayController: overlayController));
        },
      ),
    );

    final manager = easyOverlayState.dialogManagerProvider.use<_DummyManager>();

    expect(manager.animationController, isNull);
    expect(manager.isPresented, isFalse);
    expect(
        () => manager.initializeAndShow(
              EasyDialogManagerShowParams(content: Container()),
              (animation) => BasicDialogInsertStrategy(
                dialog: Container(),
              ),
            ),
        returnsNormally);

    expect(manager.animationController, isNotNull);
    expect(manager.isPresented, isTrue);

    expect(
      () => manager.hideAndDispose(
        BasicDialogRemoveStrategy(dialogId: 0),
        animate: false,
      ),
      returnsNormally,
    );

    expect(manager.animationController, isNull);
    expect(manager.isPresented, isFalse);
  });

  testWidgets('initialize and show, dispose', (widgetTester) async {
    await widgetTester.pumpWidget(
      app(
        managersSetup: (overlayController, dialogsRegistrar) {
          dialogsRegistrar.register(
              () => _DummyManager(overlayController: overlayController));
        },
      ),
    );

    final manager = easyOverlayState.dialogManagerProvider.use<_DummyManager>();

    expect(manager.animationController, isNull);
    manager.initializeAndShow(
      EasyDialogManagerShowParams(content: Container()),
      (animation) => BasicDialogInsertStrategy(
        dialog: Container(),
      ),
    );

    expect(manager.animationController, isNotNull);

    manager.dispose();

    expect(manager.animationController, isNull);
  });
}
