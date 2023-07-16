## Migration from 2.x to 3.x

Each manager has been transformed into a dialog itself:

* [PositionedDialogManager](https://pub.dev/packages/positioned_dialog_manager) -> EasyDialog.positioned
* [FullScreenDialogManager](https://pub.dev/packages/full_screen_dialog_manager) -> EasyDialog.fullScreen

There are no more "Show/Hide" parameters; the dialog contains all the required information internally.

From:

```dart
FlutterEasyDialogs.provider.showPositioned(
  PositionedShowParams(
    hideAfterDuration: Duration(milliseconds: 500)
    content: Container(
      height: 150.0,
      color: Colors.amber[900],
      alignment: Alignment.center,
      child: Text('Dialog'),
    ),
    position: EasyDialogPosition.top,
  ),
);
```

To:

```dart
FlutterEasyDialogs.show(
  EasyDialog.positioned(
    autoHideDuration: Duration(milliseconds: 500),
    content: Container(
      height: 150.0,
      color: Colors.amber[900],
      alignment: Alignment.center,
      child: Text('Dialog'),
    ),
    position: EasyDialogPosition.top,
  ),
);
```

To hide a dialog, you can now create an identifier for a specific dialog type.

From:

```dart
FlutterEasyDialogs.provider.hidePositioned(EasyDialogPosition.top)
```

To:

```dart
FlutterEasyDialogs.hide(
  PositionedDialog.identifier(
    position: EasyDialogPosition.top,
  ),
);
```

#### Decorators

Decorators and all related objects have changed too:

* Decorator -> [Decoration](https://pub.dev/documentation/flutter_easy_dialogs/3.0.0-dev.3/flutter_easy_dialogs/EasyDialogDecoration-class.html)
* Animator -> [Animation](https://pub.dev/documentation/flutter_easy_dialogs/3.0.0-dev.3/flutter_easy_dialogs/EasyDialogAnimation-class.html)
* Dismissible -> [Dismiss](https://pub.dev/documentation/flutter_easy_dialogs/3.0.0-dev.3/flutter_easy_dialogs/EasyDialogDismiss-class.html)

They all have become more flexible and universal.

Better watch this [topic](https://pub.dev/documentation/flutter_easy_dialogs/3.0.0-dev.3/topics/Decorations-topic.html) for better a understanding.