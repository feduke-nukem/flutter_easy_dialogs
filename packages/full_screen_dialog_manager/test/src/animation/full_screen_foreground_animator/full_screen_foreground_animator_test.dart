import 'package:flutter_test/flutter_test.dart';
import 'package:full_screen_dialog_manager/full_screen_dialog_manager.dart';

import '../../../helper.dart';

void main() {
  test('create all', () {
    expect(
      () => const FullScreenForegroundAnimator.bounce(),
      returnsNormally,
    );
    expect(
      () => const FullScreenForegroundAnimator.expansion(curve: testCurve),
      returnsNormally,
    );
    expect(
      () => const FullScreenForegroundAnimator.fade(curve: testCurve),
      returnsNormally,
    );
    expect(
      () => const FullScreenForegroundAnimator.bounce(),
      returnsNormally,
    );
  });
}
