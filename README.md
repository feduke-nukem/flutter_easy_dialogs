 
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
  - [Animators](#animators)
  - [Dismissible](#dismissible)
  - [Shells](#shells) 
  - [Scoping](#scoping) 
  - [Easy dialog controller](#easy-dialog-controller)
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

In your library add the following import:

```dart
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart'
```

## Setup and usage
 
Wrap your MaterialApp with ```FlutterEasyDialogs.builder()```.

```dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FlutterEasyDialogs.builder(),
    );
  }
}
```

You're done. Now you are able to call show methods from ```IEasyDialogController``` like so:
```dart
 FlutterEasyDialogs.controller.showPositioned(
      params: const PositionedShowParams(
        content: Text('dialog'),
      ),
    );
```
Or

```dart
    FlutterEasyDialogs.controller.showFullScreen(
        params: const FullScreenShowParams(
      content: Text('dialog'),
    ));
```

## Basics
#### Manager
*What is `Manager`, exactly?*
They are objects that are responsible for showing, hiding, and taking care of all related dialogs (including positioning, playing animations, inserting in overlay etc.)

We have a class that serves as the base for all `Managers` that have exactly two responsibilities: *to show* and *to hide*

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
The core thing that allows you to inject your beautiful dialogs into the `Overlay` is encapsulated within the `Insert/Remove Strategy`, which will be covered a bit later in the `Overlay` section. Now you are just need to know that they exists and they are similar to theStrategy/Command pattern.

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
Each `Manager` can provide its own complex structure for state as complex as it needs to be. For example, the **PositionedManager** stores its data in the format of another `Map`, or the **CustomManager** uses a `List of` *`integers`*
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
For the sake of simplicity, there are two derived classes. 

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

#### Animators
This is the way to animate the dialogs:

```dart
abstract class IEasyAnimator { 
  Widget animate({
    required Animation<double> parent,
    required Widget child,
  });
}
```
It is used within the `Manager` logic of showing the dialogs.

The stumbling block is `parent` argument. Simply put, it is `AnimationController` that was created by a specific `Manager` and provided to `Animator`, so it could apply some transitions or any other change-based value to the `child`.

The implementing class is `EasyAnimator`, which is simply another type of abstraction that can be extended and has the optional property of a [Curve](https://api.flutter.dev/flutter/animation/Curves-class.html) :

```dart
abstract class EasyAnimator implements IEasyAnimator {
  final Curve? curve;

  const EasyAnimator({
    this.curve,
  });
}
```

>**Note:**
There are several *`Manager-specific`* `Animators` such as **EasyPositionedAnimator** or **EasyFullScreenBackgroundAnimator**.
The point is that the usage of animators could be simplified and scoped to a single `Manager`.

#### Dismissible
Generally, it is the way to dismiss dialogs with provided [VoidCallback](https://api.flutter.dev/flutter/dart-ui/VoidCallback.html). It's responsibility is to provide specific dismissible behavior to the dialog:

```dart
abstract class IEasyDismissible {
  Widget makeDismissible(Widget dialog);
}
```

```dart
typedef OnEasyDismiss = void Function();
 
abstract class EasyDismissible implements IEasyDismissible { 
  final OnEasyDismiss? onDismiss;

  const EasyDismissible({
    this.onDismiss,
  });
}
```

Like the `Animator`, the `Dismissible` is provided to the `Manager`, and the `Manager` is responsible for hooking up all of these components into the `dialog`.

#### Shells
This is the wrapper `Widget` that provides some sort of shape to the content of the dialog. It is not mandatory, but it could be very handy to apply some additional components around the provided `content`.

#### Scoping
Some components such as **Shells** or **Dismissible** depend on `Scoping- specific` data that is providing by some `Manager`.
This is just a derived class from [InheritedWidget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html):

```dart
class _EasyScope<T extends EasyDialogScopeData> extends InheritedWidget {
  final T data;

  const _EasyScope({
    required super.child,
    required this.data,
    super.key,
  });

  @override
  bool updateShouldNotify(_EasyScope oldWidget) => oldWidget.data != data;
}
```

```dart
abstract class EasyDialogScopeData {
  const EasyDialogScopeData();
}
```

Here is some handy extension-function on `BuildContext`: 

```dart
  D readDialog<D extends EasyDialogScopeData>() =>
      EasyDialogScope.of<D>(this, listen: false);
```
#### Easy dialog controller
The highest level **API** of this package is `IEasyDialogController`. This object provides access to methods that allow the *`showing and hiding`* of dialogs of any specific `Manager`.

```dart
abstract class IEasyDialogsController { 
  Future<void> showPositioned({
    required PositionedShowParams params,
  });
 
  Future<void> hidePositioned({
    required EasyDialogPosition position,
  });
 
  Future<void> hideAllPositioned();

  Future<void> showFullScreen({
    required FullScreenShowParams params,
  });
 
  Future<void> hideFullScreen();

  T useCustom<T extends EasyDialogManager>();
}
```

The last method will be covered in more detail later. Generally, it provides access to your `CustomManagers` as a strongly-typed object. 

## Positioned 

#### Positioned Examples

<img src="https://user-images.githubusercontent.com/72284940/226207548-b32ca1e5-3896-4d89-9795-1d1868adc850.gif" width="300"><img src="https://user-images.githubusercontent.com/72284940/226208001-47b3f169-5235-415a-8fec-f438139c9414.gif" width="300">

#### Positioned customization

<img src="https://user-images.githubusercontent.com/72284940/226208034-5c1802bc-bdfd-47b9-bf72-900ad764f670.gif" width = "350">

You can observe the example in: `example/lib/screens/positioned_dialog_customization_screen.dart`

#### 
 
Slide:

![Slide][slide_positioned_banner]

Fade:

![Fade][fade_positioned_banner]

Expansion:

![Expansion][expansion_positioned_banner] 


## Full screen 
 
#### Full screen examples

<img src="https://user-images.githubusercontent.com/72284940/226210980-d3fa1560-1cd5-4694-81e5-990c3cd2a9dc.gif" width="300"><img src="https://user-images.githubusercontent.com/72284940/226211002-f85edaa0-982b-4bbe-89ed-453b1bfedf83.gif" width="300">
  


## Custom
#### Custom manager setup
If you want to use your own handmade `Manager`, you can define a class that extends `CustomManager` and optionally specify your *`hide/show`* parameters. Pay attention to the usage of [CustomInsert/Remove](#box-mutation) [Strategy](#strategies). The insertion strategy callback passes an ID of the inserted dialog entry within `EasyOverlay`, which later can be used to remove that dialog.
Lastly, it is necessary to provide a `List` of `CustomManagers` that you want to be able to use within the `IEasyDialogsController.useCustom()` method:

```dart

int? _customDialogId;

class MyDialogManager extends CustomManager<CustomManagerShowParams,
    EasyDialogManagerHideParams?> {
  MyDialogManager({required super.overlayController});

  @override
  Future<void> hide({EasyDialogManagerHideParams? params}) async {
    super.overlayController.removeDialog(
          CustomDialogRemoveStrategy(
            dialogId: _customDialogId!,
          ),
        );
  }

  @override
  Future<void> show({required CustomManagerShowParams params}) async {
    if (_customDialogId != null) {
      super.overlayController.removeDialog(
            CustomDialogRemoveStrategy(
              dialogId: _customDialogId!,
            ),
          );
    }
    super.overlayController.insertDialog(
          CustomDialogInsertStrategy(
            dialog: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 200.0,
                width: 200.0,
                color: params.color,
                child: Center(child: params.content),
              ),
            ),
            onInserted: (dialogId) => _customDialogId = dialogId,
          ),
        );
  }
}

class CustomManagerShowParams extends EasyDialogManagerShowParams {
  final Color color;

  const CustomManagerShowParams({
    required super.content,
    required this.color,
  });
}
```

```dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FlutterEasyDialogs.builder(
        customManagerBuilder: (overlayController) =>
            [MyDialogManager(overlayController: overlayController)],
      ),
    );
  }
}

```

#### Custom manager usage
Simply call with your `Manager` type provided as a generic:

```dart
    FlutterEasyDialogs.controller.useCustom<MyDialogManager>().show(
          params: CustomManagerShowParams(
            content: const Text('Custom'),
            color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0),
          ),
        );
```
#### Custom manager example
<img src="https://user-images.githubusercontent.com/72284940/226210899-89876b31-eb9d-42a6-a351-23fc1f8e896a.gif" width="300">
 



## Special thanks
Special thanks to [back_button_interceptor](https://github.com/marcglasberg/back_button_interceptor)

<!-- Links -->
[slide_positioned_banner]: https://user-images.githubusercontent.com/72284940/200048845-96a5487b-de11-442f-92e0-2cab6be9b539.gif
[fade_positioned_banner]: https://user-images.githubusercontent.com/72284940/200050223-0976a2b8-c0ff-482b-be29-4963cf4472a6.gif
[expansion_positioned_banner]: https://user-images.githubusercontent.com/72284940/200051054-cc8281cc-50a6-43b9-b5a0-38655d8919a8.gif
[modal_banner_blured]: https://user-images.githubusercontent.com/72284940/200051692-d174a805-1739-4c94-9d2f-10fdaab0cba5.gif 
