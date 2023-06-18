import 'package:flutter_easy_dialogs/src/core/easy_dialogs_controller.dart';
import 'package:flutter_easy_dialogs/src/easy_dialog_manager_controller/easy_dialog_manager_box.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper.dart';
import '../../mock.dart';

void main() {
  late EasyDialogManagerBox sut;
  late MockEasyOverlayController overlayController;

  void checkInstance<M extends EasyDialogsController>() {
    expect(() => sut.get<M>(), returnsNormally);
    expect(sut.managers[M], isA<M>());
    expect(() => sut.get<M>(), returnsNormally);
    expect(
      contains(M).matches(sut.managers, const {}),
      isTrue,
    );
  }

  setUp(() {
    sut = EasyDialogManagerBox();
    overlayController = MockEasyOverlayController();
  });

  test('create map', () {
    expect(() => EasyDialogManagerBox(), returnsNormally);
  });

  test('put manager', () {
    expect(sut.managers.isEmpty, isTrue);

    sut.put(() => BarManager(overlayController: overlayController));

    expect(
      sut.managers[BarManager],
      isA<EasyDialogManagerFactory<BarManager>>(),
    );
    expect(sut.managers.entries.length, 1);
    checkInstance<BarManager>();

    expect(
        () => sut.put(() => BarManager(overlayController: overlayController)),
        throwsAssertionError);
  });

  test('put and remove', () {
    expect(sut.managers.isEmpty, isTrue);

    sut.put(() => BarManager(overlayController: overlayController));

    expect(sut.managers.entries.length, 1);
    checkInstance<BarManager>();

    sut.remove<BarManager>();

    expect(sut.managers.isEmpty, isTrue);
  });

  test('get the same manager multiple times', () {
    sut.put(() => BarManager(overlayController: overlayController));

    final firstManagerInstance = sut.get<BarManager>();
    final secondManagerInstance = sut.get<BarManager>();
    final identical =
        same(firstManagerInstance).matches(secondManagerInstance, {});

    expect(identical, isTrue);
  });

  test('multiple put manager', () {
    sut.put(() => BarManager(overlayController: overlayController));

    expect(
      () => sut.put(() => BarManager(overlayController: overlayController)),
      throwsAssertionError,
    );
  });

  test('get manager without puting', () {
    expect(
      () => sut.get<BarManager>(),
      throwsAssertionError,
    );
  });

  test('put two managers', () {
    expect(sut.managers.isEmpty, isTrue);

    sut.put(() => BarManager(overlayController: overlayController));
    sut.put(() => FooManager(overlayController: overlayController));

    expect(
      sut.managers[BarManager],
      isA<EasyDialogManagerFactory<BarManager>>(),
    );
    expect(
      sut.managers[FooManager],
      isA<EasyDialogManagerFactory<FooManager>>(),
    );
    expect(sut.managers.entries.length, 2);
    checkInstance<BarManager>();
    checkInstance<FooManager>();

    expect(
      () => sut.put(() => BarManager(overlayController: overlayController)),
      throwsAssertionError,
    );
    expect(
      () => sut.put(() => FooManager(overlayController: overlayController)),
      throwsAssertionError,
    );
  });
}
