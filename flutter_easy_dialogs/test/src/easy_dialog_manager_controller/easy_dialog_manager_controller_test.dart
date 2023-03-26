import 'package:flutter_easy_dialogs/src/easy_dialog_manager_controller/easy_dialog_manager_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper.dart';
import '../../mock.dart';

void main() {
  late EasyDialogManagerController sut;
  late MockEasyOverlayController overlayController;

  setUp(() {
    overlayController = MockEasyOverlayController();

    sut = EasyDialogManagerController();
  });

  test('create controller', () {
    expect(() => EasyDialogManagerController(), returnsNormally);
  });

  test('register and use manager', () {
    sut.register(() => BarManager(overlayController: overlayController));

    expect(sut.managers.managers.length, 1);
    expect(() => sut.get<BarManager>(), returnsNormally);
  });

  test('register and unregister manager', () {
    expect(sut.managers.managers.isEmpty, isTrue);

    sut.register(() => BarManager(overlayController: overlayController));

    expect(sut.managers.managers.length, 1);
    expect(() => sut.get<BarManager>(), returnsNormally);

    sut.unregister<BarManager>();
    expect(sut.managers.managers.isEmpty, isTrue);
  });

  test('register and use multiple managers', () {
    sut.register(() => BarManager(overlayController: overlayController));
    sut.register(() => FooManager(overlayController: overlayController));

    expect(sut.managers.managers.length, 2);
    expect(() => sut.get<BarManager>(), returnsNormally);
    expect(() => sut.get<FooManager>(), returnsNormally);
  });
}
