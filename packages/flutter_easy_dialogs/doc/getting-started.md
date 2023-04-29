## Getting started
## Installation
In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  flutter_easy_dialogs: <latest_version>
```

You can optionally connect pre-built [EasyDialogManager](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogManager-class.html) implementations from separate packages:

```yaml
dependencies:
  full_screen_dialog_manager: <latest_version>
  positioned_dialog_manager: <latest_version>
```

In your library add the following import:

```dart
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:full_screen_dialog_manager/full_screen_dialog_manager.dart';
import 'package:positioned_dialog_manager/positioned_dialog_manager.dart';
```

## Setup and usage
 
Wrap your MaterialApp with [FlutterEasyDialogs.builder()](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/FlutterEasyDialogs/builder-constant.html) and register desired `Managers`.

```dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FlutterEasyDialogs.builder(
        /// register managers
        setupManagers: (overlayController, managerRegistry) {
          managerRegistry
            ..registerFullScreen(overlayController)
            ..registerPositioned(overlayController);
        },
      ),
    );
  }
}
```

You're done. Now you are able to call show methods from [IEasyDialogManagerProvider](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/IEasyDialogManagerProvider-class.html) like so:
```dart
FlutterEasyDialogs.provider.showPositioned(
  const PositionedShowParams(
    content: Text('dialog'),
  )
);
```
Or

```dart
FlutterEasyDialogs.provider.showFullScreen(
  const FullScreenShowParams(
    content: Text('dialog'),
  ),
);
```