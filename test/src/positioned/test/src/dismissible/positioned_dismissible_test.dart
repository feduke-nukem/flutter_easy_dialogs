import 'package:flutter_test/flutter_test.dart';
import 'package:positioned_dialog_manager/src/dismissible/positioned_dismissible.dart';

void main() {
  test('create all', () {
    expect(
      () => PositionedDismissible.tap(
        onDismissed: () {},
      ),
      returnsNormally,
    );
    expect(
      () => PositionedDismissible.swipe(
        onDismissed: () {},
      ),
      returnsNormally,
    );
    expect(
      () => PositionedDismissible.animatedTap(
        onDismissed: () {},
      ),
      returnsNormally,
    );
    expect(
      () => const PositionedDismissible.none(),
      returnsNormally,
    );
  });
}
