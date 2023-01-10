 
# FlutterEasyDialogs

Flutter overlay based service for easy usage of different kinds of 'dialogs'.  

## Features

* Different pre-built dialogs and animations
* Flexible mechanism of integrating custom self-built dialogs and animations
* Show dialogs in any place of the application

## Install

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  flutter_easy_dialogs: <latest_version>
```

In your library add the following import:

```dart
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart'
```
## Getting started
 
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


That's it. Now you are able to call show methods from ```EasyDialogController``` like so:
```dart
 FlutterEasyDialogs.dialogsController.showBanner(
      content: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.red),
        onPressed: () {},
        child: const Text(
          'BANNER',
          style: TextStyle(fontSize: 30),
        ),
      )
    );
```
Or

```dart
 FlutterEasyDialogs.dialogsController.showModalBanner(
   content: Container(
     height: 200.0,
     width: 200.0,
     color: Colors.red,
     child: const Icon(
       Icons.home,
       size: 60,
     ),
   ),
 );
```

Also you can provide your own custom dialog agent.

```dart
const customAgentName = 'customDialogAgent';
const customDialogName = 'customDialog';

class CustomDialogAgent extends EasyDialogAgentBase {
  CustomDialogAgent({required super.overlayController});

  @override
  Future<void> hide({AgentHideParams? params}) async {
    super.overlayController.removeCustomDialog(name: customDialogName);
  }

  @override
  Future<void> show({required CustomAgentShowParams params}) async {
    super.overlayController.insertCustomDialog(
          name: customDialogName,
          dialog: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200.0,
              width: 200.0,
              color: params.color,
              child: Center(child: params.content),
            ),
          ),
        );
  }
}

class CustomAgentShowParams extends AgentShowParams {
  final Color color;

  const CustomAgentShowParams({
    required super.theme,
    required super.content,
    required this.color,
  });
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(  
      builder: (context, child) {
        final builder = FlutterEasyDialogs.builder( 
          customAgentBuilder: (overlayController) => {
            customAgentName:
                CustomDialogAgent(overlayController: overlayController)
          },
        );

        return builder(context, child);
      },
    );
  }
}
```


## Usage

Show dialog example:

```dart
 FlutterEasyDialogs.dialogsController.showBanner(
      onDismissed: () {},
      content: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.red),
        onPressed: () {},
        child: const Text(
          'BANNER',
          style: TextStyle(fontSize: 30),
        ),
      ),
      durationUntilHide: Duration(milliseconds: _autoHideDuration.toInt()),
      autoHide: true,
      position: EasyDialogPosition.top,
      animationType: EasyPositionedAnimationType.fade,
      dismissibleType: EasyPositionedDismissibleType.swipe,
    );
```

## Theming

It's possible to pre-configure some settings for dialogs using ```FlutterEasyDialogsThemeData```.

```dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        final builder = FlutterEasyDialogs.builder(
          theme: FlutterEasyDialogsThemeData(
            easyBannerTheme: EasyBannerThemeData.light(),
            easyModalBannerTheme: EasyModalBannerThemeData.light(),
          ),
        );

        return builder(context, child);
      },
    );
  }
}
```

## Positioned dialogs 

Slide:

![Slide][slide_positioned_banner]

Fade:

![Fade][fade_positioned_banner]

Expansion:

![Expansion][expansion_positioned_banner] 


## Fullscreen dialogs 
 
![Modal_Banner][modal_banner_blured]


Special thanks to [back_button_interceptor](https://github.com/marcglasberg/back_button_interceptor)

<!-- Links -->
[slide_positioned_banner]: https://user-images.githubusercontent.com/72284940/200048845-96a5487b-de11-442f-92e0-2cab6be9b539.gif
[fade_positioned_banner]: https://user-images.githubusercontent.com/72284940/200050223-0976a2b8-c0ff-482b-be29-4963cf4472a6.gif
[expansion_positioned_banner]: https://user-images.githubusercontent.com/72284940/200051054-cc8281cc-50a6-43b9-b5a0-38655d8919a8.gif
[modal_banner_blured]: https://user-images.githubusercontent.com/72284940/200051692-d174a805-1739-4c94-9d2f-10fdaab0cba5.gif
