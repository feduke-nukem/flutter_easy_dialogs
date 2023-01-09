import 'dart:math' as math;

import 'package:example/custom_dialog_agent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

class CustomAgentDialogsScreen extends StatefulWidget {
  const CustomAgentDialogsScreen({Key? key}) : super(key: key);

  @override
  State<CustomAgentDialogsScreen> createState() =>
      _CustomAgentDialogsScreenState();
}

class _CustomAgentDialogsScreenState extends State<CustomAgentDialogsScreen> {
  final _easyDialogsController = FlutterEasyDialogs.dialogsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom agent'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _easyDialogsController.showCustom(
                name: customAgentName,
                params: CustomAgentShowParams(
                  theme: FlutterEasyDialogsTheme.of(context),
                  content: const Text('Custom'),
                  color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                      .withOpacity(1.0),
                ),
              ),
              child: const Text('Show from custom agent'),
            ),
            ElevatedButton(
              onPressed: () =>
                  _easyDialogsController.hideCustom(name: customAgentName),
              child: const Text('Hide from custom agent'),
            ),
          ],
        ),
      ),
    );
  }
}
