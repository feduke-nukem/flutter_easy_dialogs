import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helper.dart';

void main() {
  testWidgets('bloc/unblock button', (tester) async {
    await tester.pumpWidget(
      app(
        managersSetup: (overlayController, dialogsRegistrar) {
          dialogsRegistrar.register(
              () => _DummyManager(overlayController: overlayController));
        },
      ),
    );

    final manager = easyOverlayState.dialogManagerProvider.use<_DummyManager>();

    expect(manager.blockBackButton, returnsNormally);
    expect(manager.unblockBackButton, returnsNormally);
  });
}

class _DummyManager extends EasyDialogManager with BlockAndroidBackButtonMixin {
  _DummyManager({required super.overlayController});

  @override
  Future<void> hide({required EasyDialogManagerHideParams? params}) async {}

  @override
  Future<void> show({required EasyDialogManagerShowParams? params}) async {}
}
