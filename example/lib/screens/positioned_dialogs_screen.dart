import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

class PositionedDialogsScreen extends StatelessWidget {
  const PositionedDialogsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Positioned dialogs'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _showBanner(
                context,
                true,
                EasyDialogPosition.top,
              ),
              child: const Text('Show autohide top banner'),
            ),
            ElevatedButton(
              onPressed: () => _showBanner(
                context,
                false,
                EasyDialogPosition.top,
              ),
              child: const Text('Show top banner'),
            ),
            ElevatedButton(
              onPressed: () => _showBanner(
                context,
                false,
                EasyDialogPosition.center,
              ),
              child: const Text('Show center banner'),
            ),
            ElevatedButton(
              onPressed: () => _showBanner(
                context,
                false,
                EasyDialogPosition.bottom,
              ),
              child: const Text('Show bot banner'),
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            onPressed: () => FlutterEasyDialogs.of(context).hideAllBanners(),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }

  void _showBanner(
    BuildContext context,
    bool autoHide,
    EasyDialogPosition position,
  ) {
    FlutterEasyDialogs.of(context).showBanner(
      onDismissed: () {},
      content: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.red),
        onPressed: () {},
        child: const Text(
          'BANNER YO',
          style: TextStyle(fontSize: 30),
        ),
      ),
      autoHide: autoHide,
      position: position,
      animationType: EasyPositionedAnimationType.fade,
    );
  }
}
