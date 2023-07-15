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
      color: Colors.amber[900],
      alignment: Alignment.center,
      child: Text('$_selectedPosition'),
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
      color: Colors.amber[900],
      alignment: Alignment.center,
      child: Text('$_selectedPosition'),
    ),
  ),
);
```
The result will be the same:

#### Chain
You can chain two decorations one after another:

```dart
FlutterEasyDialogs.show(
  EasyDialog.positioned(
    decoration: const EasyDialogDecoration.chain(
      EasyDialogAnimation.fade(),
      EasyDialogDismiss.animatedTap(),
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
Or chain multiple. In fact, this will provide the same output as `combine` but using a different syntax:

```dart
FlutterEasyDialogs.show(
  EasyDialog.positioned(
    decoration: const EasyDialogAnimation.fade()
        .chained(const EasyDialogAnimation.expansion())
        .chained(const EasyDialogDismiss.animatedTap()),
    content: Container(
      height: 150.0,
      color: Colors.amber[900],
      alignment: Alignment.center,
      child: Text('$_selectedPosition'),
    ),
  ),
);
```

#### Builder
You are able to define your custom decoration using `builder` constructor:

```dart
FlutterEasyDialogs.show(
  EasyDialog.positioned(
    decoration: EasyDialogDecoration.builder(
      (_, dialog) => FadeTransition(
        opacity: dialog.context.animation,
        child: dialog.content,
      ),
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
      color: Colors.white,
      width: double.infinity,
      height: 200.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Hello World'),
          ElevatedButton(
            onPressed: () {
              FlutterEasyDialogs.hide(
                PositionedDialog.identifier(
                  position: EasyDialogPosition.top,
                ),
              );
            },
            child: const Text('Close'),
          ),
        ],
      ),
    ),
  ),
);
```

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