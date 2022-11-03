import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

class ModalBannerScreen extends StatelessWidget {
  const ModalBannerScreen({Key? key}) : super(key: key);

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
              onPressed: () async {
                final controller = FlutterEasyDialogs.of(context);
                await controller.showModalBanner(
                  contentAnimationType: EasyFullScreenContentAnimationType.fade,
                  onDismissed: controller.hideModalBanner,
                  backgroundColor: Colors.black,
                  content: Container(
                    height: 200.0,
                    width: 200.0,
                    color: Colors.red,
                    child: const Icon(
                      Icons.home,
                      size: 60,
                    ),
                  ),
                );
              },
              child: const Text('Show modal banner'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final controller = FlutterEasyDialogs.of(context);

          await controller.hideModalBanner();
        },
      ),
    );
  }
}
