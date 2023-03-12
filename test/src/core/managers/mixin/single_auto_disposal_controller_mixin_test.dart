import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helper.dart';

class _DummyManager extends EasyDialogManagerBase<ManagerShowParamsBase?,
    ManagerHideParamsBase?> with SingleAutoDisposalControllerMixin {
  _DummyManager({required super.overlayController});

  int? _dialogId;

  @override
  Future<void> hide({ManagerHideParamsBase? params}) {
    return hideAndDispose(CustomDialogRemoveStrategy(dialogId: _dialogId!));
  }

  @override
  Future<void> show({ManagerShowParamsBase? params}) {
    return initializeAndShow(
      params,
      (animation) => CustomDialogInsertStrategy(
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
    ManagerShowParamsBase? params,
  ) =>
      AnimationController(
        vsync: const TestVSync(),
        duration: Duration.zero,
      );
}

void main() {
  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance
      ..resetEpoch()
      ..platformDispatcher.onBeginFrame = null
      ..platformDispatcher.onDrawFrame = null;
  });

  testWidgets('show once', (widgetTester) async {
    await widgetTester.pumpWidget(
      app(
        customManagerBuilder: (overlayController) {
          return [
            _DummyManager(
              overlayController: overlayController,
            )
          ];
        },
      ),
    );

    final manager =
        easyOverlayState.easyDialogsController.useCustom<_DummyManager>();

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
        customManagerBuilder: (overlayController) {
          return [
            _DummyManager(
              overlayController: overlayController,
            )
          ];
        },
      ),
    );

    final manager =
        easyOverlayState.easyDialogsController.useCustom<_DummyManager>();

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
}
