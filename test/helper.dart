import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/overlay/overlay.dart';

final _key = GlobalKey<EasyOverlayState>();

EasyOverlayState get easyOverlayState => _key.currentState!;

const dialogKey = ValueKey('dialog');

Widget app({
  CustomManagerBuilder? customManagerBuilder,
  Widget? child,
}) =>
    MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return FlutterEasyDialogsTheme(
          data: FlutterEasyDialogsThemeData.basic(),
          child: Material(
            child: EasyOverlay(
              key: _key,
              customManagersBuilder: customManagerBuilder,
              initialEntries: [
                EasyOverlayAppEntry(
                  builder: (context) => child ?? const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      },
      home: child != null
          ? Builder(
              builder: (context) {
                return child;
              },
            )
          : null,
    );
