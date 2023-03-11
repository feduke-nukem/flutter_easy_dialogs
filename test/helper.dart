import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/overlay/overlay.dart';

Widget get app => MaterialApp(
      builder: (context, child) {
        final builder = FlutterEasyDialogs.builder();

        return builder(context, child);
      },
      home: EasyOverlay(
        key: _key,
      ),
    );
final _key = GlobalKey<EasyOverlayState>();

EasyOverlayState get easyOverlayState => _key.currentState!;

const dialogKey = ValueKey('dialog');
