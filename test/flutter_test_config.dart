import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

const _tolerance = 0.13;

const _devices = [
  Device.phone,
  Device.iphone11,
  Device(name: 'google_pixel_4', size: Size(360, 760)),
  Device(name: 'iphone_se', size: Size(320, 568)),
];

Future<void> testExecutable(FutureOr<void> Function() testMain) {
  return GoldenToolkit.runWithConfiguration(
    () async {
      await loadAppFonts();
      await testMain();

      if (goldenFileComparator is LocalFileComparator) {
        goldenFileComparator = CybedomComparator(
          '${(goldenFileComparator as LocalFileComparator).basedir}/goldens',
        );
      }
    },
    config: GoldenToolkitConfiguration(
      defaultDevices: _devices,
      enableRealShadows: true,
    ),
  );
}

class CybedomComparator extends LocalFileComparator {
  CybedomComparator(String testFile) : super(Uri.parse(testFile));

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    if (!result.passed && result.diffPercent >= _tolerance) {
      final error = await generateFailureOutput(result, golden, basedir);
      throw FlutterError(error);
    }
    if (!result.passed) {
      log(
        'A tolerable difference of ${result.diffPercent * 100}% was found when comparing $golden.',
        level: 2000,
      );
    }

    return result.passed || result.diffPercent <= _tolerance;
  }
}
