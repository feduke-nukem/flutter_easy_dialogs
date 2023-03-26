import 'package:examples/examples.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:positioned_dialog_manager/positioned_dialog_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FlutterEasyDialogs.builder(
        setupManagers: (overlayController, managerRegistrar) {
          managerRegistrar.registerPositioned(overlayController);
        },
      ),
      title: 'Positioned Dialog Manager demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PositionedDialogManagerRoutes.home.screen,
    );
  }
}
