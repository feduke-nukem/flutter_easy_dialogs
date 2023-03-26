import 'package:examples/examples.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:full_screen_dialog_manager/full_screen_dialog_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Full Screen Dialog Manager App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FullScreenDialogManagerRoutes.home.screen,
      builder: FlutterEasyDialogs.builder(
        /// Register manager
        setupManagers: (overlayController, managerRegistrar) {
          managerRegistrar.registerFullScreen(overlayController);
        },
      ),
    );
  }
}
