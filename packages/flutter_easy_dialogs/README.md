 
# FlutterEasyDialogs

- [Introduction](#introduction)
  - [Installation](#installation)
  - [Setup and usage](#setup-and-usage)
- [Basics](#basics)
  - [Manager](#manager)
      - [Parameters](#parameters)
      - [Strategies](#strategies)
  - [Overlay](#overlay)
      - [Controller](#controller)
      - [Box](#box)
      - [Box mutation](#box-mutation)
      - [Easy overlay](#easy-overlay)
  - [Decorators](#decorators)
      - [Animators](#animators)
      - [Dismissible](#dismissible)
      - [Shells](#shells)  
  - [Registering and using](#registering-and-using) 
- [Positioned](#positioned)
  - [Examples](#positioned-examples)
  - [Customization](#positioned-customization)
- [Full screen](#full-screen)
  - [Examples](#full-screen-examples)
- [Custom](#custom)
  - [Setup](#custom-manager-setup)
  - [Usage](#custom-manager-usage)
  - [Example](#custom-manager-example)
- [Special thanks](#special-thanks)


## Introduction

#### What is `FlutterEasyDialogs` ?
It is an open-source package for the Flutter framework that provides easy-to-use and customizable dialogs based on [Overlay](https://api.flutter.dev/flutter/widgets/Overlay-class.html)  for use in your mobile app. With this library, you can quickly create and display dialogs such as alerts, confirmation dialogs, info dialogs, and more. The library is designed to be lightweight, efficient, and easy to use, making it ideal for developers who want to add dialog functionality to their apps without having to write complex code.

With `FlutterEasyDialogs` you can quickly create and customize dialogs. The package provides a flexible API that allows to customize various aspects of the dialogs, including animations, appearance, positions and providing completely handmade realizations of dialog manipulation.

Overall, if you're looking for an easy-to-use and customizable dialog package for your Flutter app, you should take a try `FlutterEasyDialogs`.

## Installation
In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  flutter_easy_dialogs: <latest_version>
```

You can optionally connect pre-built `Manager` implementations from separate packages:

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
 
Wrap your MaterialApp with ```FlutterEasyDialogs.builder()``` and register desired `Managers`.

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

You're done. Now you are able to call show methods from ```IEasyDialogManagerProvider``` like so:
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

## Basics
#### Manager
*What is `Manager`, exactly?*
They are objects that are responsible for showing, hiding, and taking care of all related dialogs (including positioning, playing animations, inserting in overlay etc.)

We have a class that serves as the base for all `Managers` that have exactly two responsibilities: *`to show`* and *`to hide`*

```dart
abstract class EasyDialogManager<S extends EasyDialogManagerShowParams?,
    H extends EasyDialogManagerHideParams?> {
  final IEasyOverlayController overlayController;
 
  const EasyDialogManager({
    required this.overlayController,
  });

  Future<void> show({
    required S params,
  });

  Future<void> hide({
    required H params,
  });
}
```
You may wonder what `IEasyOverlayController` is and why it's there. We'll talk about it a bit later.
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
The mandatory things are *`Widget`-`content`* and *`EasyAnimationConfiguration`-`animationConfiguration`*. The purpose of the first one is pretty obvious, while the last one is responsible for providing options that the `Manager` may use to configure the `AnimationController`.
#### Strategies
The core thing that allows you to inject your beautiful dialogs into the `Overlay` is encapsulated within the `Insert/Remove Strategy`, which will be covered a bit later in the `Overlay` section. Now you are just need to know that they exists and they are similar to the `Strategy/Command` pattern.

#### Overlay
##### Controller
Here comes `IEasyOverlayController` which suddenly has pretty similar responsibilities to that of the `Manager`, such as inserting and removing dialogs into the `Overlay` using two methods.

```dart
abstract class IEasyOverlayController implements TickerProvider {
  void insertDialog(EasyOverlayBoxInsert strategy);

  void removeDialog(EasyOverlayBoxRemove strategy);
}
```

You may notice the `strategy` named argument, and you would be correct in thinking that it refers to the `strategies` mentioned earlier.

##### Box
It is the strict variation of `Map` with generic types which is using only for storing `Overlay` entries and associated `Managers`:

```dart  
abstract class IEasyOverlayBox {
  void put(Object key, Object value);

  T? remove<T>(Object key);

  T? get<T>(Object key);

  T putIfAbsent<T>(Object key, T Function() ifAbsent);
}
```

>**Note**:  
Each `Manager` can provide its own complex structure for state as complex as it needs to be. For example, the **PositionedManager** stores its data in the format of another `Map`, or **BasicDialogInsertStrategy** uses a `List of` *`integers`* as identifiers of inserted dialogs.

##### Box mutation
So that's it - the `strategy` for `inserting/removing` `Manager` data into `IEasyOverlayBox`. The basis of this is called **BoxMutation**, which has the single responsibility of mutating the storage state of this `Box`:

```dart
abstract class EasyOverlayBoxMutation<M extends EasyDialogManager,
    R extends EasyOverlayEntry?> {
  const EasyOverlayBoxMutation();

  Type get key => M;

  R apply(IEasyOverlayBox box);
}
```
The result of applying of the `mutation strategy` must be an any derived class of `EasyOverlayEntry` (specific class derived from [OverlayEntry](https://api.flutter.dev/flutter/widgets/OverlayEntry-class.html)) which can later could be used within `IEasyOverlayController` to insert that `entry` into [EasyOverlay](#easy-overlay).
For the sake of simplicity, there are two classes. 

One is for `inserting`: 

```dart
abstract class EasyOverlayBoxInsert<M extends EasyDialogManager>
    extends EasyOverlayBoxMutation<M, EasyOverlayEntry> {
  final Widget dialog;

  const EasyOverlayBoxInsert({
    required this.dialog,
  });
}
```
Which provides the *`dialog`* to be inserted into `EasyOverlay`.

And the another is for `removing`, which result could be `nullable` as it could be no such *`dialog entry`* existing withing the `IEasyOverlayBox`

```dart 
abstract class EasyOverlayBoxRemove<M extends EasyDialogManager>
    extends EasyOverlayBoxMutation<M, EasyOverlayEntry?> {
  const EasyOverlayBoxRemove();
}
```
##### Easy overlay
This is the core widget that provides all possibilities of dialogs to appear at any time and in any place within the wrapped application.
Its state is responsible for storing `IEasyOverlayBox` and implementing `IEasyOverlayController`. There isn't much to know, to be honest.


## Decorators

This is a special abstraction that is commonly used by `Managers` to **decorate** the behavior or appearance of the content provided to be presented within the `dialog`.

It's very simple to use:

```dart
abstract class EasyDialogDecorator<D extends EasyDialogDecoratorData?> {
  const EasyDialogDecorator();

  Widget decorate(D data);
}
```

You just need to implement the **decorate** method and provide your `EasyDialogDecoratorData` to it. The only mandatory property is `dialog`. As you may notice, you can extend this data class and specify a `generic` parameter within the `EasyDialogDecorator` bounds to be able to pass any kind of data as per your needs.

```dart
class EasyDialogDecoratorData { 
  final Widget dialog;

  const EasyDialogDecoratorData({required this.dialog});
}
```

#### Animators
This is the way to animate the dialogs:

```dart
abstract class EasyDialogAnimator<D extends EasyDialogAnimatorData>
    extends EasyDialogDecorator<D> {
  /// Desired curve to be applied to the animation.
  final Curve curve;
 
  const EasyDialogAnimator({this.curve = Curves.linear});
}
```
It is used within the `Manager` logic of showing the dialogs with specific data:

```dart
class EasyDialogAnimatorData extends EasyDialogDecoratorData {
  final Animation<double> parent;

  const EasyDialogAnimatorData({required this.parent, required super.dialog});
}
```

The stumbling block is `parent` argument. Simply put, it is `AnimationController` that was created by a specific `Manager` and provided to `Animator`, so it could apply some transitions or any other change-based value to the `dialog`.

>**Note:**
There are several *`Manager-specific`* `Animators` such as **PositionedAnimator** or **FullScreenBackgroundAnimator**.
The point is that the usage of animators could be simplified and scoped to a single `Manager`.

#### Dismissible
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
* `EasyDismissibleData`, that provides the `dismissHandler` function which is optional. Sometimes it is necessary to perform certain actions when the actual `onDismissed` callback is called:

```dart
class EasyDismissibleData<P extends EasyDismissiblePayload>
    extends EasyDialogDecoratorData { 
  final DismissHandler<P>? dismissHandler;
 
  const EasyDismissibleData({required super.dialog, this.dismissHandler});
}
```
The desired `payload` that the dismissible may pass back to the `Manager` on handle, as always, this class may be extended and specified in the generic parameter of an `EasyDialogDismissible`:

```dart
class EasyDismissiblePayload {
  final bool instantDismiss;

  const EasyDismissiblePayload({this.instantDismiss = false});
}
```

Similar to the **Animators**, the **Dismissible** is provided to the `Manager`, and the `Manager` is responsible for providing the specified dismissible behavior to the `dialog`.

#### Shells
This is the wrapper `Widget` that provides some sort of shape to the content of the dialog. It is not mandatory, but it could be very handy to apply some additional components around the provided `content`.
 

#### Registering and using

Before the `Manager` can be used, it must be registered using `IEasyDialogsManagerRegistry`, which is a simple *register/unregister* class. An example of this can be observed [there](#setup-and-usage)

Now you are able to **use** registered `Manager` via `FlutterEasyDialogs.provider`:

```dart
// Show
FlutterEasyDialogs.provider.use<MyDialogManager>().show(
       params: const EasyDialogManagerShowParams(
         content: Text('My custom manager'),
       ),
     );

// Hide
FlutterEasyDialogs.provider.use<MyDialogManager>().hide();

```

The specified **use** method provides access to the instance of a registered `Manager`. You don't need to worry about instances and other details, as all registrations and initializations are done ***lazily***.  

## Positioned 

#### Positioned Examples

![positioned-1](https://user-images.githubusercontent.com/72284940/227770860-d5885960-2a22-4d3b-bd91-1e0e5488fc7e.gif)
![positioned-2](https://user-images.githubusercontent.com/72284940/227770870-b2a43e65-01fc-4b90-b518-82fb3539c09b.gif)
![positioned-3](https://user-images.githubusercontent.com/72284940/227770871-d0b60af3-10f3-4112-b67c-b42763953456.gif)
![positioned-4](https://user-images.githubusercontent.com/72284940/227770872-8050c2fa-0388-48aa-b121-c4176898e794.gif)
![positioned-5](https://user-images.githubusercontent.com/72284940/227770876-6b10e8f7-e29c-472e-a926-7beb454cc41e.gif)



#### Positioned customization

![positioned-customize](https://user-images.githubusercontent.com/72284940/227770921-d9cb0a95-c689-4e68-9242-012f8988370b.gif)

#### 
 
Slide:

![Slide][slide_positioned_banner]

Fade:

![Fade][fade_positioned_banner]

Expansion:

![Expansion][expansion_positioned_banner] 


## Full screen 
 
#### Full screen examples

![full-screen-1](https://user-images.githubusercontent.com/72284940/227770949-599014fb-45b4-4081-b6e4-2defce0d73a0.gif)
![full-screen-2](https://user-images.githubusercontent.com/72284940/227770950-13bbaa09-5e2e-4524-aa86-2b1ffe1256d8.gif)
![full-screen-3](https://user-images.githubusercontent.com/72284940/227770952-1c0b4d15-b987-4fa1-9a1b-bb6f94b0565e.gif)


#### Customization

![full-screen-custom](https://user-images.githubusercontent.com/72284940/227770982-cf2e8efd-8395-440f-aeed-a1b6dd83b66a.gif)
![full-screen-full-custom](https://user-images.githubusercontent.com/72284940/227770993-39ad7bc1-4fa3-4056-b244-192be231d87a.gif)


## Custom
#### Custom manager setup
If you want to use your own handmade `Manager`, you can define a class that extends `EasyDialogManager` and optionally specify your *`hide/show`* parameters. Pay attention to the usage of [BasicInsert/Remove](#box-mutation) [Strategy](#strategies). The insertion strategy callback passes an ID of the inserted dialog entry within `EasyOverlay`, which later can be used to remove that dialog.
Lastly, it is necessary to [register](#setup-and-usage) your `Manager` before it is used:

```dart

class MyDialogManager extends EasyDialogManager<EasyDialogManagerShowParams,
    EasyDialogManagerHideParams> with SingleAutoDisposalControllerMixin {
  MyDialogManager({required super.overlayController});

  int? _id;

  @override
  Future<void> hide({required EasyDialogManagerHideParams params}) => _hide();

  Future<void> _hide() =>
      hideAndDispose(BasicDialogRemoveStrategy(dialogId: _id!));

  @override
  Future<void> show({required EasyDialogManagerShowParams params}) async {
    if (isPresented) await _hide();

    await initializeAndShow(params, (animation) {
      var dialog = params.content;

      dialog = const CustomAnimator()
          .decorate(EasyDialogAnimatorData(parent: animation, dialog: dialog));

      dialog = const CustomDismissible().decorate(
        EasyDismissibleData(
          dialog: dialog,
          dismissHandler: (_) => _hide(),
        ),
      );

      return BasicDialogInsertStrategy(
        dialog: dialog,
        onInserted: (dialogId) => _id = dialogId,
      );
    });
  }

  @override
  AnimationController createAnimationController(
    TickerProvider vsync,
    EasyDialogManagerShowParams params,
  ) =>
      params.animationConfiguration.createController(vsync);
}

class CustomAnimator extends EasyDialogAnimator {
  const CustomAnimator();

  @override
  Widget decorate(EasyDialogAnimatorData data) {
    return FadeTransition(
      opacity: data.parent,
      child: data.dialog,
    );
  }
}

class CustomDismissible extends EasyDialogDismissible {
  const CustomDismissible();

  @override
  Widget decorate(EasyDismissibleData<EasyDismissiblePayload> data) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {
        data.dismissHandler?.call(const EasyDismissiblePayload());
        super.onDismissed?.call();
      },
      child: data.dialog,
    );
  }
}


```

#### Custom manager usage
Simply call with your `Manager` type provided as a generic:

```dart
FlutterEasyDialogs.provider.use<MyDialogManager>().show(
      params: EasyDialogManagerShowParams(
        content: Container(
          alignment: Alignment.center,
          color: Colors.amber.withOpacity(0.6),
          padding: const EdgeInsets.all(30.0),
          child: const Text(
            'My custom manager',
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
```
#### Custom manager example

![custom-manager](https://user-images.githubusercontent.com/72284940/227771010-cf28c0e1-804e-43bd-ab68-3ade29e6528c.gif)




## Special thanks
Special thanks to [back_button_interceptor](https://github.com/marcglasberg/back_button_interceptor)

<!-- Links -->
[slide_positioned_banner]: https://user-images.githubusercontent.com/72284940/200048845-96a5487b-de11-442f-92e0-2cab6be9b539.gif
[fade_positioned_banner]: https://user-images.githubusercontent.com/72284940/200050223-0976a2b8-c0ff-482b-be29-4963cf4472a6.gif
[expansion_positioned_banner]: https://user-images.githubusercontent.com/72284940/200051054-cc8281cc-50a6-43b9-b5a0-38655d8919a8.gif
[modal_banner_blured]: https://user-images.githubusercontent.com/72284940/200051692-d174a805-1739-4c94-9d2f-10fdaab0cba5.gif 
