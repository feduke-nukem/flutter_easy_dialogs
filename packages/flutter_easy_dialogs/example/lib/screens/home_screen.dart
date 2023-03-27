import 'package:example/screens/custom_dialog_manager_screen.dart';
import 'package:examples/examples.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Dialogs Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context)
                  .push(PositionedDialogManagerRoutes.home.route),
              child: const Text('Positioned dialogs example'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context)
                  .push(FullScreenDialogManagerRoutes.home.route),
              child: const Text('Full screen dialogs example'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CustomDialogManagerScreen(),
                ),
              ),
              child: const Text('Custom dialog manager example'),
            )
          ],
        ),
      ),
    );
  }
}
