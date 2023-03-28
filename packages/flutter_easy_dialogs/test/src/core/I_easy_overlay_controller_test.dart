import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_overlay_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('markNeedsRebuild called', () {
    final entry = _DummyEntry(builder: (_) => Container());

    expect(() => entry.markNeedsBuild(), throwsFlutterError);
  });
}

class _DummyEntry extends EasyOverlayEntry {
  _DummyEntry({required super.builder});
}
