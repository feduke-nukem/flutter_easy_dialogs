## Dialogs

#### Positioned dialogs
This type of dialogs is used to show at a specific place on the screen using [EasyDialogPosition](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogPosition.html).

```dart
FlutterEasyDialogs.show(
  EasyDialog.positioned(
    position: EasyDialogPosition.top,
    content: Container(
      height: 150.0,
      color: Colors.amber[900],
      alignment: Alignment.center,
      child: Text('Dialog'),
    ),
  ),
);
```
Or:

```dart
Container(
  height: 150.0,
  color: Colors.amber[900],
  alignment: Alignment.center,
  child: Text('Dialog'),
).positioned(position: EasyDialogPosition.top).show();
```

<div style="display:flex; flex-wrap:wrap;">
    <a style="flex:1;">
        <img src="https://github.com/feduke-nukem/flutter_easy_dialogs/assets/72284940/aecc16a6-ddb7-4668-b9fc-57b07b9a742c" width="170"/>
    </a>
    <a style="flex:1;">
        <img src="https://github.com/feduke-nukem/flutter_easy_dialogs/assets/72284940/58d9c6b8-236e-492d-92ff-5a4588ffa1e0" width="170"/>
    </a>
    <a style="flex:1;">
        <img src="https://github.com/feduke-nukem/flutter_easy_dialogs/assets/72284940/a241b14a-764c-4c4d-b863-e146a0496f1b" width="170"/>
    </a>
</div>
 

#### FullScreen dialogs

These dialogs are intended to cover all available space on the screen and be presented one at a time. There is a special [behavior](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/FullScreenDialog/onAndroidPop.html) available to detect the Android software back button and handle it:

```dart
FlutterEasyDialogs.show(
  EasyDialog.fullScreen( 
    content: Container(
      height: 150.0,
      color: Colors.amber[900],
      alignment: Alignment.center,
      child: Text('Dialog'),
    ),
  ),
);
```

Or:

```dart
Container(
  height: 150.0,
  color: Colors.amber[900],
  alignment: Alignment.center,
  child: Text('Dialog'),
).fullScreen().show();
```

<div style="display:flex; flex-wrap:wrap;">
    <a style="flex:1;">
        <img src="https://github.com/feduke-nukem/flutter_easy_dialogs/assets/72284940/f619a488-1226-47df-b49a-7ac3da36a4f7" width="170"/>
    </a>
    <a style="flex:1;">
        <img src="https://github.com/feduke-nukem/flutter_easy_dialogs/assets/72284940/42eee846-6507-47a4-9967-650095798702" width="170"/>
    </a>
    <a style="flex:1;">
        <img src="https://github.com/feduke-nukem/flutter_easy_dialogs/assets/72284940/8c2d2d76-aae9-4297-9c82-debac236af7d" width="170"/>
    </a>
</div>

#### Basic parameters
- [content](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialog/content.html) - [widget](https://api.flutter.dev/flutter/widgets/Widget-class.html) that is desired to be shown.
- [animation configuration](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogAnimationConfiguration-class.html) - responsible for configuring animation duration, start value, etc. It also provides an opportunity to create a configuration with an external [AnimationController](https://api.flutter.dev/flutter/animation/AnimationController-class.html) that will drive the dialog animation.
- [auto hide duration](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialog/autoHideDuration.html): duration after which the dialog will be automatically hidden.
- [decoration](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogDecoration-class.html): a provided decoration that will be applied to the content.

#### Context
Each dialog has its own [context](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogContext-class.html), which is a class that contains helpful methods and properties, such as the animation associated with the dialog:

```dart
dialog.context.animation;
dialog.context.hideDialog();
dialog.context.vsync;
```
