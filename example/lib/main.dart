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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      builder: (context, child) {
        final builder = FlutterEasyDialogs.builder();

        return builder(context, child);
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _showBanner(
    BuildContext context,
    bool autoHide,
    EasyDialogPosition position,
  ) {
    FlutterEasyDialogs.of(context).showBanner(
      onDismissed: () {},
      content: ElevatedButton(
        onPressed: () {},
        child: const Text(
          'BANNER YO',
          style: TextStyle(fontSize: 30),
        ),
      ),
      autoHide: autoHide,
      position: position,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
}
