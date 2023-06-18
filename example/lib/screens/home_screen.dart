import 'package:example/full_screen/routes.dart';
import 'package:example/positioned/routes.dart';
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
              onPressed: () =>
                  Navigator.of(context).push(PositionedDialogRoutes.home.route),
              child: const Text('Positioned dialogs example'),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).push(FullScreenDialogRoutes.home.route),
              child: const Text('Full screen dialogs example'),
            ),
          ],
        ),
      ),
    );
  }
}
