#### Registering and using

Before the [EasyDialogManager](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/EasyDialogManager-class.html) can be used, it must be registered using [IEasyDialogManagerRegistry](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/IEasyDialogManagerRegistry-class.html), which is a simple *register/unregister* class. An example of this can be observed [there][setup-and-usage]

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

The specified **[use](https://pub.dev/documentation/flutter_easy_dialogs/latest/flutter_easy_dialogs/IEasyDialogManagerProvider/use.html)** method provides access to the instance of a registered `Manager`. You don't need to worry about instances and other details, as all registrations and initializations are done ***lazily***.  

<!-- Links -->
[setup-and-usage]: https://pub.dev/documentation/flutter_easy_dialogs/latest/topics/Getting%20started-topic.html