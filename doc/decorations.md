## Decorations

This class is intended to add specific look or behavior to the dialog content.

There are several approaches to applying decoration to the dialog:

- **[Combine](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogDecoration/EasyDialogDecoration.combine.html)**
- **[Chain](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogDecoration/EasyDialogDecoration.chain.html)**
- **[Builder](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogDecoration/EasyDialogDecoration.builder.html)**
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

Here is a more complex example:

```dart
FlutterEasyDialogs.show(
  EasyDialog.fullScreen(
    autoHideDuration: const Duration(seconds: 1),
    animationConfiguration:
        EasyDialogAnimationConfiguration.withController(
      _controller,
      willReverse: true,
    ),
    decoration: EasyDialogDecoration.builder(
      (context, dialog) => AnimatedBuilder(
        animation: dialog.context.animation,
        builder: (context, child) => ColoredBox(
          color: Colors.yellow.withOpacity(
            dialog.context.animation.value.clamp(0.0, 0.5),
          ),
          child: child,
        ),
        child: Center(
          child: dialog.content
              .animate(controller: _controller)
              .fade()
              .rotate()
              .scale()
              .blur(
                begin: const Offset(20.0, 20.0),
                end: const Offset(0.0, 0.0),
              ),
        ),
      ),
    ),
    content: Container(
      height: 150.0,
      width: 150.0,
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

![ezgif-4-6b864d08f9](https://github.com/feduke-nukem/flutter_easy_dialogs/assets/72284940/2d4cc2a9-8b4b-46de-b77f-ffa810e38452)

#### Single decoration
That's it, you can provide only a single decoration.

```dart
FlutterEasyDialogs.show(
  EasyDialog.positioned(
    position: EasyDialogPosition.bottom,
    decoration: const EasyDialogAnimation.bounce(),
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

![ezgif-4-afefdbe946](https://github.com/feduke-nukem/flutter_easy_dialogs/assets/72284940/661b90ca-61a4-4bd7-adb5-d546347909cf)

#### Animation
Just need to mention that there is specific type of decoration that is used to provide animation to dialog.

Blur background and slide from top:

```dart
FlutterEasyDialogs.show(
  EasyDialog.positioned(
    autoHideDuration: const Duration(milliseconds: 500),
    decoration: EasyDialogDecoration.combine([
      const PositionedAnimation.verticalSlide(),
      const EasyDialogAnimation.fade(),
      EasyDialogAnimation.blurBackground(
        backgroundColor: Colors.black.withOpacity(0.2),
      )
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

![ezgif-4-6738b05ec0](https://github.com/feduke-nukem/flutter_easy_dialogs/assets/72284940/2efdf13d-3ab8-48fe-83a3-b71ba9e4d2a1)

Fullscreen fade background and bounce:

```dart
FlutterEasyDialogs.show(
  EasyDialog.fullScreen(
    autoHideDuration: const Duration(milliseconds: 500),
    decoration: EasyDialogDecoration.combine([
      const EasyDialogAnimation.bounce(),
      EasyDialogAnimation.fadeBackground(
        backgroundColor: Colors.black.withOpacity(0.2),
      ),
    ]),
    content: Center(
      child: Container(
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
  ),
);
```

![ezgif-4-18231c2ada](https://github.com/feduke-nukem/flutter_easy_dialogs/assets/72284940/92778c4d-9f42-4a61-8102-f0ffb01a662b)

There are some helpful extension methods:

* `reversed` - will reverse the decided animation.
* `interval` - will play the animation within the provided interval.
* `tween sequence` - will apply the provided `TweenSequence` to the animation.

A bit of fun:

```dart
FlutterEasyDialogs.show(
  EasyDialog.positioned(
    autoHideDuration: const Duration(milliseconds: 500),
    decoration: EasyDialogDecoration.combine([
      const EasyDialogAnimation.fade().interval(0.0, 0.5),
      const EasyDialogAnimation.expansion().reversed(),
      EasyDialogAnimation.fadeBackground(
        backgroundColor: Colors.black.withOpacity(0.6),
      ).tweenSequence(
        TweenSequence([
          TweenSequenceItem(
              tween: Tween(begin: 0.0, end: 0.5), weight: 100),
        ]),
      ),
    ]),
```

![ezgif-4-2a9bea6cda](https://github.com/feduke-nukem/flutter_easy_dialogs/assets/72284940/29ddebc3-cee8-4c60-9c7f-9332a2ba0ccd)

#### Dismiss
Generally, it is the way to dismiss dialogs with provided callback which returns some result.

There are a few important things you need to know:
- [OnEasyDismissed](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/OnEasyDismissed.html): a callback that fires when the dialog is dismissed. You can provide some data to be returned as a result of showing the dialog.
- [EasyWillDismiss](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyWillDismiss.html): a callback that fires when the dialog is about to be dismissed. You can decide whether it should be dismissed or not. It is quite similar to [WillPopCallback](https://api.flutter.dev/flutter/widgets/WillPopCallback.html).

```dart 
final res = await FlutterEasyDialogs.show<int>(
  EasyDialog.positioned(
    decoration: const EasyDialogAnimation.fade().chained(
      PositionedDismiss.swipe(
        onDismissed: () => 5,
        direction: PositionedDismissibleSwipeDirection.vertical,
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

![ezgif-4-2c10546796](https://github.com/feduke-nukem/flutter_easy_dialogs/assets/72284940/06c272be-ae67-40c9-ae95-f57533effe33)

#### Imagination

You can achieve fascinating results; you are only limited by your imagination!

```dart
FlutterEasyDialogs.show(
  EasyDialog.positioned(
    decoration: EasyDialogDecoration.combine([
      const EasyDialogAnimation.fade(),
      const EasyDialogAnimation.expansion(),
      const EasyDialogDismiss.animatedTap(),
      const PositionedDismiss.swipe(instantly: false),
      EasyDialogAnimation.fadeBackground(
        backgroundColor: Colors.black.withOpacity(0.6),
      ),
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

![ezgif-4-5450049742](https://github.com/feduke-nukem/flutter_easy_dialogs/assets/72284940/b0912391-9a62-4eb3-aa75-3da8bc3d85ff)


