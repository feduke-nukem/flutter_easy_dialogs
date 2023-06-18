#### Dialog manager
*What is `Manager`, exactly?*
They are objects that are responsible for showing, hiding, and taking care of all related dialogs (including positioning, playing animations, inserting in overlay etc.)

We have a class that serves as the base for all `Managers` that have exactly two responsibilities: *`to show`* and *`to hide`*

```dart
abstract class EasyDialogManager<S extends EasyDialogManagerShowParams?,
    H extends EasyDialogManagerHideParams?> {
  final IEasyOverlayController overlayController;
 
  const EasyDialogManager({required this.overlayController});

  Future<void> show({required S params});

  Future<void> hide({required H params});
}
```
You may wonder what [IEasyOverlayController](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/IEasyOverlayController-class.html) is and why it's there. We'll talk about it a bit later.
#### Parameters
The generic data which the `Manager` operates on are the Show/Hide parameters. Each `Manager` is able to extend the base parameters or not define them at all:
```dart
abstract class EasyDialogManagerShowParams { 
  final Widget content;
 
  final EasyAnimationConfiguration animationConfiguration;
 
  const EasyDialogManagerShowParams({
    required this.content,
    this.animationConfiguration = const EasyAnimationConfiguration(),
  });
}
 
abstract class EasyDialogManagerHideParams { 
  const EasyDialogManagerHideParams();
}
```
The mandatory things are [Widget](https://api.flutter.dev/flutter/widgets/Widget-class.html)-*`content`* and [EasyDialogAnimatorConfiguration](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogAnimatorConfiguration-class.html)-*`animationConfiguration`*. The purpose of the first one is pretty obvious, while the last one is responsible for providing options that the `Manager` may use to configure the [AnimationController](https://api.flutter.dev/flutter/animation/AnimationController-class.html).
#### Strategies
The core thing that allows you to inject your beautiful dialogs into the `Overlay` is encapsulated within the [Insert](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyOverlayBoxInsert-class.html)/[Remove](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyOverlayBoxRemove-class.html) Strategy, which will be covered a bit later in the [Overlay](https://pub.dev/documentation/flutter_easy_dialogs/latest/topics/Overlay-topic.html) section. Now you are just need to know that they exists and they are similar to the `Strategy/Command` pattern.