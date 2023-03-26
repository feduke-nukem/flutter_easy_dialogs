import 'package:example/my_dialog_manager/my_dialog_manager.dart';
import 'package:example/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:full_screen_dialog_manager/full_screen_dialog_manager.dart';
import 'package:positioned_dialog_manager/positioned_dialog_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Dialogs demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      builder: FlutterEasyDialogs.builder(
        /// register managers
        setupManagers: (overlayController, managerRegistrar) {
          managerRegistrar
            ..registerFullScreen(overlayController)
            ..registerPositioned(overlayController)
            ..register(
              () => MyDialogManager(overlayController: overlayController),
            );
        },
      ),
    );
  }
}
