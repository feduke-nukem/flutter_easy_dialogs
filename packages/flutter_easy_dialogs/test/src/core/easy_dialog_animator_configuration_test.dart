import 'package:flutter_easy_dialogs/src/core/easy_dialog_animator_configuration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('create configuration', () {
    expect(() => EasyDialogAnimatorConfiguration(), returnsNormally);
    expect(() => EasyDialogAnimatorConfiguration.unbounded(), returnsNormally);
  });

  test('create configuration and controller', () {
    const startValue = 1.0;
    const duration = Duration(seconds: 1);
    const reverseDuration = const Duration(seconds: 3);
    const lowerBound = 0.5;
    const upperBound = 2.0;

    final configuration = EasyDialogAnimatorConfiguration(
      startValue: startValue,
      duration: duration,
      reverseDuration: reverseDuration,
      lowerBound: lowerBound,
      upperBound: upperBound,
    );

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

  test('create unbounded configuration', () {
    const startValue = 1.0;
    const duration = Duration(seconds: 1);
    const reverseDuration = const Duration(seconds: 3);

    final configuration = EasyDialogAnimatorConfiguration.unbounded(
      startValue: startValue,
      duration: duration,
      reverseDuration: reverseDuration,
    );

    expect(configuration.duration, duration);
    expect(configuration.reverseDuration, reverseDuration);
    expect(configuration.lowerBound, double.negativeInfinity);
    expect(configuration.upperBound, double.infinity);
    expect(configuration.startValue, startValue);

    final controller = configuration.createController(TestVSync());

    expect(controller.duration, duration);
    expect(controller.reverseDuration, reverseDuration);
    expect(controller.lowerBound, double.negativeInfinity);
    expect(controller.upperBound, double.infinity);
    expect(controller.value, startValue);
  });
}
