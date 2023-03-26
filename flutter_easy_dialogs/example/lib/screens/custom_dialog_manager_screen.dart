import 'package:example/my_dialog_manager/my_dialog_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

class CustomDialogManagerScreen extends StatelessWidget {
  const CustomDialogManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dialog Manager example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () =>
              FlutterEasyDialogs.controller.use<MyDialogManager>().show(
                    params: EasyDialogManagerShowParams(
                      content: Container(
                        alignment: Alignment.center,
                        color: Colors.amber.withOpacity(0.6),
                        padding: const EdgeInsets.all(30.0),
                        child: const Text(
                          'My custom manager',
                          style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
          child: const Text('Show'),
        ),
      ),
    );
  }
}
