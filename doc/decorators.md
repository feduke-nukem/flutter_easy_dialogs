## [Decorators](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogDecorator-class.html)

This is a special abstraction that is commonly used by [Managers][manager] to **decorate** the behavior or appearance of the content provided to be presented within the `dialog`.

It's very simple to use:

```dart
abstract class EasyDialogDecorator<D extends EasyDialogDecoratorData?> {
  const EasyDialogDecorator();

  Widget decorate(D data);
}
```

You just need to implement the **decorate** method and provide your [EasyDialogDecoratorData](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogDecoratorData-class.html) to it. The only mandatory property is `dialog`. As you may notice, you can extend this data class and specify a `generic` parameter within the [EasyDialogDecorator](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogDecorator-class.html) bounds to be able to pass any kind of data as per your needs.

```dart
class EasyDialogDecoratorData { 
  final Widget dialog;

  const EasyDialogDecoratorData({required this.dialog});
}
```

#### [Animators][animator]
This is the way to animate the dialogs:

```dart
abstract class EasyDialogAnimator<D extends EasyDialogAnimatorData>
    extends EasyDialogDecorator<D> {
  /// Desired curve to be applied to the animation.
  final Curve curve;
 
  const EasyDialogAnimator({this.curve = Curves.linear});
}
```
It is used within the [Manager][manager] logic of showing the dialogs with specific data:

```dart
class EasyDialogAnimatorData extends EasyDialogDecoratorData {
  final Animation<double> parent;

  const EasyDialogAnimatorData({required this.parent, required super.dialog});
}
```

The stumbling block is `parent` argument. Simply put, it is [AnimationController](https://api.flutter.dev/flutter/animation/AnimationController-class.html) that was created by a specific [Manager]([manager]) and provided to [Animator][animator], so it could apply some transitions or any other change-based value to the `dialog`.

#### [Dismissible][dismissible]
Generally, it is the way to dismiss dialogs with provided [VoidCallback](https://api.flutter.dev/flutter/dart-ui/VoidCallback.html). It's responsibility is to provide specific dismissible behavior to the dialog and to handle the dismissing:

```dart 
typedef OnEasyDismissed = void Function();
 
typedef DismissHandler<P extends EasyDismissiblePayload> = FutureOr<void>
    Function(P payload);

abstract class EasyDialogDismissible<D extends EasyDismissibleData<P>,
    P extends EasyDismissiblePayload> extends EasyDialogDecorator<D> { 
  final OnEasyDismissed? onDismissed;
 
  const EasyDialogDismissible({this.onDismissed});
}
```

There are several data classes:
* [EasyDismissibleData](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDismissibleData-class.html), that provides the [dismissHandler](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/DismissHandler.html) function which is optional. Sometimes it is necessary to perform certain actions when the actual [onDismissed](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogDismissible/onDismissed.html) callback is called:

```dart
class EasyDismissibleData<P extends EasyDismissiblePayload>
    extends EasyDialogDecoratorData { 
  final DismissHandler<P>? dismissHandler;
 
  const EasyDismissibleData({required super.dialog, this.dismissHandler});
}
```
The desired [payload](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDismissiblePayload-class.html) that the dismissible may pass back to the [Manager][manager] on handle, as always, this class may be extended and specified in the generic parameter of an [EasyDialogDismissible][dismissible]:

```dart
class EasyDismissiblePayload {
  final bool instantDismiss;

  const EasyDismissiblePayload({this.instantDismiss = false});
}
```

Similar to the **[Animators][animator]**, the **[Dismissible][dismissible]** is provided to the [Manager][manager], and the [Manager][manager] is responsible for providing the specified dismissible behavior to the `dialog`.

#### Shells
This is the wrapper [Widget](https://api.flutter.dev/flutter/widgets/Widget-class.html) that provides some sort of shape to the content of the dialog. It is not mandatory, but it could be very handy to apply some additional components around the provided `content`.

<!-- Links -->
[animator]: https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogAnimator-class.html
[manager]: https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogManager-class.html
[dismissible]: https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogDismissible-class.html