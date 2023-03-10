import 'package:example/custom_dialog_agent.dart';
import 'package:example/easy_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Dialogs Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: EasyRouter.initialRoute,
      onGenerateRoute: EasyRouter.onGenerateRoute,
      builder: (context, child) {
        final builder = FlutterEasyDialogs.builder(
          /// Provide custom dialog agent
          customAgentBuilder: (overlayController) =>
              [CustomDialogAgent(overlayController: overlayController)],
        );

        return builder(context, child);
      },
    );
  }
}
