**Q:** What can I do if I already have some builders in my `MaterialApp`?

**A:** `FlutterEasyDialogs.builder()` returns a function, so you may simply call it:

```dart
MaterialApp.router(
  builder: (context, child) {
    final mediaQueryData = MediaQuery.of(context);
    final easyDialogsBuilder = FlutterEasyDialogs.builder();
    return MediaQuery(
      data: mediaQueryData.copyWith(textScaleFactor: 1.0),
      child: easyDialogsBuilder(context, child),
    );
  },
);
```

**Q:** I didn't see an option like: 'autoHide'. How to make a dialog to stay until I hide it manually besides setting autoHideDuration: const Duration(days: 999)?

**A:** Each dialog has a property named `autoHideDuration`, and if you pass `null`, it won't automatically hide the dialog. You can then hide the dialog manually later:

```dart
Container(
  color: Colors.blueAccent,
  width: double.infinity,
  height: 200.0,
  child: const Text('Hello World'),
).positioned(autoHideDuration: null).show();

// or
FlutterEasyDialogs.show(
  EasyDialog.positioned(
    autoHideDuration: null,
    content: Container(
      color: Colors.blueAccent,
      width: double.infinity,
      height: 200.0,
      child: const Text('Hello World'),
    ),
  ),
);
```