## Dialogs

#### Positioned dialogs
This type of dialogs is used to show at a specific place on the screen using [EasyDialogPosition]().

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

<a>
    <img src="https://user-images.githubusercontent.com/72284940/227770860-d5885960-2a22-4d3b-bd91-1e0e5488fc7e.gif" width="160"/>
</a>
<a>
    <img src="https://user-images.githubusercontent.com/72284940/227770870-b2a43e65-01fc-4b90-b518-82fb3539c09b.gif" width="160"/>
</a> 
<a>
    <img src="https://user-images.githubusercontent.com/72284940/227770871-d0b60af3-10f3-4112-b67c-b42763953456.gif" width="160"/>
</a> 

#### FullScreen dialogs

These dialogs are intended to cover all available space on the screen and be presented one at a time. There is a special behavior available to detect the Android software back button and handle it:

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

<a>
    <img src="https://user-images.githubusercontent.com/72284940/227770952-1c0b4d15-b987-4fa1-9a1b-bb6f94b0565e.gif" width="160"/>
</a>
<a>
    <img src="https://user-images.githubusercontent.com/72284940/227770982-cf2e8efd-8395-440f-aeed-a1b6dd83b66a.gif" width="160"/>
</a>
<a>
    <img src="https://user-images.githubusercontent.com/72284940/227770993-39ad7bc1-4fa3-4056-b244-192be231d87a.gif" width="160"/>
</a>

#### Basic parameters
- content - [widget](https://api.flutter.dev/flutter/widgets/Widget-class.html) that is desired to be shown.
- [animation configuration](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogAnimationConfiguration-class.html) - responsible for configuring animation duration, start value, etc. It also provides an opportunity to create a configuration with an external [AnimationController](https://api.flutter.dev/flutter/animation/AnimationController-class.html) that will drive the dialog animation.
- auto hide duration: duration after which the dialog will be automatically hidden.
- [decoration](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogDecoration-class.html): a provided decoration that will be applied to the content.

#### Context
Each dialog has its own context, which is a class that contains helpful methods and properties, such as the animation associated with the dialog:

```dart
dialog.context.animation;
dialog.context.hideDialog();
dialog.context.vsync;
```