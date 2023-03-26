import 'package:flutter_test/flutter_test.dart';
import 'package:full_screen_dialog_manager/full_screen_dialog_manager.dart';

void main() {
  test('create all', () {
    expect(
      () => FullScreenDismissible.gesture(
        onDismissed: () {},
      ),
      returnsNormally,
    );
    expect(
      () => const FullScreenDismissible.none(),
      returnsNormally,
    );
  });
}
