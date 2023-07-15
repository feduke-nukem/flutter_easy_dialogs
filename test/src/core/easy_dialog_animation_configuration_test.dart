import 'package:flutter_easy_dialogs/src/core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper.dart';

void main() {
  test('create configuration', () {
    expect(() => EasyDialogAnimationConfiguration.bounded(), returnsNormally);
    expect(
        () => EasyDialogAnimationConfiguration.withController(
              createTestController(),
            ),
        returnsNormally);
    expect(() => EasyDialogAnimationConfiguration.unbounded(), returnsNormally);
  });

  test('create configuration and controller, all fields are passed correctly',
      () {
    const startValue = 1.0;
    const duration = Duration(seconds: 1);
    const reverseDuration = const Duration(seconds: 3);
    const lowerBound = 0.5;
    const upperBound = 2.0;

    final configuration = EasyDialogAnimationConfiguration.bounded(
      startValue: startValue,
      duration: duration,
      reverseDuration: reverseDuration,
      lowerBound: lowerBound,
      upperBound: upperBound,
    ) as AnimationConfigurationBounded;

    expect(configuration.duration, duration);
    expect(configuration.reverseDuration, reverseDuration);
    expect(configuration.lowerBound, lowerBound);
    expect(configuration.upperBound, upperBound);
    expect(configuration.startValue, startValue);

    final controller = configuration.createController(TestVSync());

    expect(controller.duration, duration);
    expect(controller.reverseDuration, reverseDuration);
    expect(controller.lowerBound, lowerBound);
    expect(controller.upperBound, upperBound);
    expect(controller.value, startValue);
  });

  test('create unbounded configuration, all fields are passed correctly', () {
    const startValue = 1.0;
    const duration = Duration(seconds: 1);
    const reverseDuration = const Duration(seconds: 3);

    final configuration = EasyDialogAnimationConfiguration.unbounded(
      startValue: startValue,
      duration: duration,
      reverseDuration: reverseDuration,
    ) as AnimationConfigurationUnbounded;

    expect(configuration.duration, duration);
    expect(configuration.reverseDuration, reverseDuration);
    expect(configuration.startValue, startValue);

    final controller = configuration.createController(TestVSync());

    expect(controller.duration, duration);
    expect(controller.reverseDuration, reverseDuration);
    expect(controller.lowerBound, double.negativeInfinity);
    expect(controller.upperBound, double.infinity);
    expect(controller.value, startValue);
  });

  test('create configuration with controller, controller passed correctly', () {
    final controller = createTestController();

    final configuration =
        EasyDialogAnimationConfiguration.withController(controller)
            as AnimationConfigurationWithController;

    expect(identical(configuration.controller, controller), isTrue);
  });
}
