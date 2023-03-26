import 'package:flutter_test/flutter_test.dart';
import 'package:full_screen_dialog_manager/full_screen_dialog_manager.dart';

import '../../../helper.dart';

void main() {
  test('create all', () {
    expect(
      () => const FullScreenBackgroundAnimator.blur(curve: testCurve),
      returnsNormally,
    );
    expect(
      () => const FullScreenBackgroundAnimator.fade(curve: testCurve),
      returnsNormally,
    );
    expect(
      () => const FullScreenBackgroundAnimator.none(),
      returnsNormally,
    );
  });
}
