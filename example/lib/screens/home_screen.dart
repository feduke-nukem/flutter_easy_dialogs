import 'package:example/easy_router.dart';
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
                  .pushNamed(EasyRouter.positionedDialogsRoute),
              child: const Text('Positioned dialogs example'),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(EasyRouter.modalBannerRoute),
              child: const Text('Modal banner example'),
            )
          ],
        ),
      ),
    );
  }
}
