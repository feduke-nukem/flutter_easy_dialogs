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
  void _showBanner(BuildContext context) {
    final dialogController = FlutterEasyDialogs.of(context);

    dialogController.showBanner(
      content: ElevatedButton(
        onPressed: () {},
        child: const Text(
          'BANNER YO',
          style: TextStyle(fontSize: 30),
        ),
      ),
      autoHide: true,
      animationType: EasyDialogsAnimationType.slide,
      position: EasyDialogPosition.top,
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
            const Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          onPressed: () => _showBanner(context),
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        );
      }),
    );
  }
}
