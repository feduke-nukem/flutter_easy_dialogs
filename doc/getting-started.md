## Getting started
## Installation
In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  flutter_easy_dialogs: <latest_version>
```

In your library add the following import:

```dart
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
```

## Setup and usage
 
Wrap your MaterialApp with [FlutterEasyDialogs.builder()](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/FlutterEasyDialogs/builder-constant.html) and you are ready to go.

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FlutterEasyDialogs.builder(),
    );
  }
}
```

Now you are able to call show methods from [FlutterEasyDialogs](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/FlutterEasyDialogs-class.html) like so:
```dart
FlutterEasyDialogs.show(
  EasyDialog.positioned(
    decoration: const EasyDialogAnimation.fade(),
    content: Container(
      height: 150.0,
      color: Colors.blue[900],
      alignment: Alignment.center,
      child: const Text(
        'Dialog',
        style: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
        ),
      ),
    ),
  ),
);
```

![ezgif-1-c274042f92](https://github.com/feduke-nukem/flutter_easy_dialogs/assets/72284940/2d632324-cb62-40b2-a757-bd9e96b8af4e)

Or to hide with the help of specific dialog identifier:

```dart
FlutterEasyDialogs.hide(
  PositionedDialog.identifier(
    position: EasyDialogPosition.top,
  ),
);
```

You can await and and finish dialog showing with some result:

```dart
final result = await FlutterEasyDialogs.show<int>(
  EasyDialog.positioned(
    content: Container(
      height: 150.0,
      color: Colors.amber[900],
      alignment: Alignment.center,
      child: Text('$_selectedPosition'),
    ),
    position: EasyDialogPosition.bottom,
  ),
);

await FlutterEasyDialogs.hide(
  PositionedDialog.identifier(
    position: EasyDialogPosition.bottom,
  ),
  result: 5,
);
```

If needed, there is an option to hide multiple dialogs at once.

```dart
FlutterEasyDialogs.hideWhere<PositionedDialog>(
  (dialog) =>
      dialog.position == EasyDialogPosition.bottom ||
      dialog.position == EasyDialogPosition.top,
);
```

#### Extension

There is an extension that provides alternative ways to show and hide dialogs.

```dart
final dialog = EasyDialog.positioned(
  content: Container(
    height: 150.0,
    color: Colors.amber[900],
    alignment: Alignment.center,
    child: Text('Dialog'),
  ),
  position: _selectedPosition,
);

await dialog.show();
await dialog.hide();
```
