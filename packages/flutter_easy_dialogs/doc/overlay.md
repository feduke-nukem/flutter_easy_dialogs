#### Overlay
##### [Controller][controller]
Here comes [IEasyOverlayController][controller] which suddenly has pretty similar responsibilities to that of the `Manager`, such as inserting and removing dialogs into the [Overlay](https://api.flutter.dev/flutter/widgets/Overlay-class.html) using two methods.

```dart
abstract class IEasyOverlayController implements TickerProvider {
  void insertDialog(EasyOverlayBoxInsert strategy);

  void removeDialog(EasyOverlayBoxRemove strategy);
}
```

You may notice the `strategy` named argument, and you would be correct in thinking that it refers to the `strategies` mentioned earlier.

##### [Box](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/IEasyDialogsOverlayBox-class.html)
It is the strict variation of [Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) with generic types which is using only for storing [Overlay](https://api.flutter.dev/flutter/widgets/Overlay-class.html) entries and associated `Managers`:

```dart  
abstract class IEasyDialogsOverlayBox {
  void put(Object key, Object value);

  T? remove<T>(Object key);

  T? get<T>(Object key);

  T putIfAbsent<T>(Object key, T Function() ifAbsent);
}
```

>**Note**:  
Each `Manager` can provide its own complex structure for state as complex as it needs to be. For example, the **[PositionedDialogManager](https://pub.dev/packages/positioned_dialog_manager)** stores its data in the format of another `Map`, or **[BasicDialogInsertStrategy](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/BasicDialogInsertStrategy-class.html)** uses a `List of` *`integers`* as identifiers of inserted dialogs.

##### [Box mutation][box-mutation]
So that's it - the `strategy` for `inserting/removing` `Manager` data into [IEasyDialogsOverlayBox](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/IEasyDialogsOverlayBox-class.html). The basis of this is called **[BoxMutation][box-mutation]**, which has the single responsibility of mutating the storage state of this `Box`:

```dart
abstract class EasyOverlayBoxMutation<M extends EasyDialogManager,
    R extends EasyOverlayEntry?> {
  const EasyOverlayBoxMutation();

  Type get key => M;

  R apply(IEasyOverlayBox box);
}
```
The result of applying of the `mutation strategy` must be an any derived class of [EasyOverlayEntry](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyOverlayEntry-class.html) (specific class derived from [OverlayEntry](https://api.flutter.dev/flutter/widgets/OverlayEntry-class.html)) which can later could be used within [IEasyOverlayController][controller] to insert that `entry` into [EasyOverlay](#easy-overlay).
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
Which provides the *`dialog`* to be inserted into `EasyDialogsOverlay`.

And the another is for `removing`, which result could be `nullable` as it could be no such *`dialog entry`* existing withing the [IEasyDialogsOverlayBox](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/IEasyDialogsOverlayBox-class.html)

```dart 
abstract class EasyOverlayBoxRemove<M extends EasyDialogManager>
    extends EasyOverlayBoxMutation<M, EasyOverlayEntry?> {
  const EasyOverlayBoxRemove();
}
```
##### EasyDialogsOverlay
This is the core widget that provides all possibilities of dialogs to appear at any time and in any place within the wrapped application.
Its state is responsible for storing [IEasyDialogsOverlayBox](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/IEasyDialogsOverlayBox-class.html) and implementing [IEasyOverlayController][controller]. There isn't much to know, to be honest.


<!-- Links -->
[controller]: https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/IEasyOverlayController-class.html
[box-mutation]: https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyOverlayBoxMutation-class.html