## [Decorations](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogDecoration-class.html)

This class is intended to add specific look or behavior to the dialog content.

There are several approaches to applying decoration to the dialog:

- **Combine**
- **Chain**
- **Builder**
- **Single**

There is no limit to the quantity of decorations.

#### Combine
It always happens that there are multiple decorations intended to be applied to a dialog. Easy enough, provided list will be applied in a sequential way:

```dart
FlutterEasyDialogs.show(
  EasyDialog.positioned(
    decoration: const EasyDialogDecoration.combine([
      EasyDialogAnimation.fade(),
      EasyDialogAnimation.expansion(),
      EasyDialogDismiss.animatedTap(),
    ]),
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
or:
```dart
FlutterEasyDialogs.show(
  EasyDialog.positioned(
    decoration: const EasyDialogAnimation.fade().combined([
      const EasyDialogAnimation.expansion(),
      const EasyDialogDismiss.animatedTap(),
    ]),
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
The result will be the same:

![ezgif-2-89b886cfea](https://github.com/feduke-nukem/flutter_easy_dialogs/assets/72284940/7b019125-64b1-4a7d-909a-2040d467a585)

#### Chain
You can chain two decorations one after another:

```dart
FlutterEasyDialogs.show(
  EasyDialog.positioned(
    decoration: const EasyDialogDecoration.chain(
      EasyDialogAnimation.fade(),
      PositionedDismiss.swipe(),
    ),
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

![ezgif-2-bcdedfeb8f](https://github.com/feduke-nukem/flutter_easy_dialogs/assets/72284940/ff70ba46-0339-4062-a938-8473f9f05562)


Or chain multiple. In fact, this will provide the same output as `combine` but using a different syntax:

```dart
FlutterEasyDialogs.show(
  EasyDialog.positioned(
    decoration: const EasyDialogAnimation.fade()
        .chained(const EasyDialogAnimation.expansion())
        .chained(const EasyDialogDismiss.animatedTap()),
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

![ezgif-2-89b886cfea](https://github.com/feduke-nukem/flutter_easy_dialogs/assets/72284940/7b019125-64b1-4a7d-909a-2040d467a585)

#### Builder
You are able to define your custom decoration using `builder` constructor:

```dart
FlutterEasyDialogs.show(
  EasyDialog.positioned(
    decoration: EasyDialogDecoration.builder(
      (context, dialog) => ScaleTransition(
        scale: dialog.context.animation,
        child: dialog.content,
      ),
    ),
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

![ezgif-4-622106eb6e](https://github.com/feduke-nukem/flutter_easy_dialogs/assets/72284940/7a816a8e-6b8c-4227-b331-1d58a5ed0d9c)


You can achieve cool behaviors with this one. For example, you can use other packages such as [flutter_animate](https://pub.dev/packages/flutter_animate) to create impressive effects.

```dart
FlutterEasyDialogs.show(
  EasyDialog.positioned(
    animationConfiguration:
        EasyDialogAnimationConfiguration.withController(
      _controller,
      willReverse: true,
    ),
    decoration: EasyDialogDecoration.builder(
      (context, dialog) => dialog.content
          .animate(controller: _controller)
          .scale(curve: Curves.fastOutSlowIn)
          .shake()
          .elevation()
          .slide()
          .fadeIn(),
    ),
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

![ezgif-2-6ee2f2df2f](https://github.com/feduke-nukem/flutter_easy_dialogs/assets/72284940/d3b96e2a-c86e-41ed-b1c8-c5a6ece7cd8c)

#### Single decoration
That's it, you can provide only a single decoration.

```dart
FlutterEasyDialogs.show(
  EasyDialog.positioned(
    decoration: const EasyDialogAnimation.fade(),
    content: Container(
      height: 150.0,
      color: Colors.amber[900],
      alignment: Alignment.center,
      child: Text('$_selectedPosition'),
    ),
  ),
);
```

#### Animation
Just need to mention that there is specific type of decoration that is used to provide animation to dialog.

#### [Dismiss][dismiss]
Generally, it is the way to dismiss dialogs with provided callback which returns some result.

There are a few important things you need to know:
- OnEasyDismissed: a callback that fires when the dialog is dismissed. You can provide some data to be returned as a result of showing the dialog.
- EasyWillDismiss: a callback that fires when the dialog is about to be dismissed. You can decide whether it should be dismissed or not. It is quite similar to [WillPopCallback](https://api.flutter.dev/flutter/widgets/WillPopCallback.html).

```dart 
final result = FlutterEasyDialogs.show<String>(
  EasyDialog.positioned(
    decoration: EasyDialogDismiss.tap(
      onDismissed: () => 'result',
      willDismiss: () => Future.delayed(Duration(seconds: 2), () => true),
    ),
    content: Container(
      height: 150.0,
      color: Colors.amber[900],
      alignment: Alignment.center,
      child: Text('$_selectedPosition'),
    ),
  ),
);
```

<!-- Links -->
[dismiss]: https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogDismiss-class.html
