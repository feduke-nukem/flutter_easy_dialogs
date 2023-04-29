## Custom
#### Custom manager setup
If you want to use your own handmade `Manager`, you can define a class that extends [EasyDialogManager](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogManager-class.html) and optionally specify your *[hide](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogManagerHideParams-class.html)/[show](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogManagerShowParams-class.html)* parameters. Pay attention to the usage of [BasicDialogInsertStrategy](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/BasicDialogInsertStrategy-class.html)/[BasicDialogRemoveStrategy](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/BasicDialogRemoveStrategy-class.html) strategy. The insertion strategy callback passes an ID of the inserted dialog entry within `EasyDialogsOverlay`, which later can be used to remove that dialog.
Lastly, it is necessary to [register](https://pub.dev/documentation/flutter_easy_dialogs/latest/topics/Registering%20and%20using-topic.html) your `Manager` before it is used:

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