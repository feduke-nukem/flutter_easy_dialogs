## 4.0.1
* **FIX:** Fixed https://github.com/feduke-nukem/flutter_easy_dialogs/issues/29

## 4.0.0
* **BREAKING:** Every dialog now has it's own id and could be shown with more control ([issue 27](https://github.com/feduke-nukem/flutter_easy_dialogs/issues/27))
* **BREAKING** The default curve for all animations are now `Curves.linear` ([issue 25](https://github.com/feduke-nukem/flutter_easy_dialogs/issues/25))


## 3.2.0
* **FEATURE:** Added draggable ability for the dialogs ([issue 23](https://github.com/feduke-nukem/flutter_easy_dialogs/issues/23))

## 3.1.2
* **FIX:** Fixed "Concurrent modification during iteration" in `hideWhere` #20
* **FIX:** Fixed the inability to await the result from the `show` method due to awaiting the animation controller's `forward` method when the dialog was hidden before the animation is completed.

## 3.1.1+2
* **DOC:** Added FAQ

## 3.1.1+1
* **DOC:** Improved documentation

## 3.1.1
* **FIX:** Fixed default slideHorizontal direction to leftToRight
* **FIX:** Fixed androidPop method dismiss select from context
* **FIX:** Removed FullScreenDismiss due to useless existence since introducing extensions

## 3.1.0
* **FEAT:** Added extensions syntax style
* **FEAT:** All animations and dismisses are common to use

## 3.0.0+2
* **DOC:** Improved documentation

## 3.0.0+1
* **DOC:** Improved documentation

## 3.0.0
* Major release

## 3.0.0-dev.4+1
* **DOC:** Improved documentation

## 3.0.0-dev.4
* **DOC:** Improved documentation
* **FEAT:** More flexible animations

## 3.0.0-dev.3+1
* **DOC:** Improved documentation

## 3.0.0-dev.3
* **DOC:** Improved documentation

## 3.0.0-dev.2
* **DOC:** Improved documentation
* **FIX:** Removed collection dependency

## 3.0.0-dev.1

* **BREAKING:** 
The package conception has been completely redesigned, focusing solely on dialogs (eliminating any managers). 
There are no longer `Decorators`, but rather `Decoration`, providing a more efficient and flexible way to describe dialog behavior. 
Separation of packages is no longer necessary as everything is now contained within this single package. 
The minimum required Dart version has been increased to `3.0.0`.
* **DOC:** The documentation and examples have been completely reworked.
* **FEAT:** Dialogs can now return result values.showing
## 2.0.8+6

* Improved documentation
## 2.0.8+5

* Fixed dart doc topics
## 2.0.8+4

* Updated dart doc topics and readme
## 2.0.8+3

* Added dart doc topics
## 2.0.8+2

* Updated README.MD

## 2.0.8+1

* Updated README.MD

## 2.0.8

* Fixed FlutterEasyDialogs export

## 2.0.7+3

* Fixed repository link

## 2.0.7+2

* Updated readme 

## 2.0.7+1

* Fixed readme typos 

## 2.0.7

* Fixed readme typos 

## 2.0.6

* Fixed readme typos 
## 2.0.5
* Provider is now public as there is no opportunity to make static extension methods in Dart.

* Readme updated.
## 2.0.4

* Readme updated.

* `IEasyDialogManagerController` replaced with `IEasyDialogsManagerProvider` as it makes more sense now.

* The controller property of FlutterEasyDialogs has been removed, and replaced with a simple use method.

* Renamed `IEasyDialogsManagerRegistrar` to `IEasyDialogsManagerRegistry`.

## 2.0.3

* Readme update

## 2.0.2

* Readme changes

## 2.0.0

* Major release

## 2.0.1-alpha-2

* Reworked animators, shells, dismissibles.
* Moved managers to separated packages.
* Reworked usage/register api.

## 2.0.1-alpha

* Updated README.md 

## 2.0.0-alpha (Breaking changes)

* Completely redesigned API and project structure
* BREAKING: `showModalBanner`, `hideModalBanner`, `hideAllBanners`, `hideBanner`, `showBanner` are deprecated now and will be removed in 2.1.0
* BREAKING: Removed theming
* BREAKING: New providing animations approach. Previous will be removed in 2.1.0
* Covered with tests 
* `EasyAnimationSettings` renamed to `EasyAnimationConfiguration` and extended. Provided `FullScreenDialogManager` and `PositionedDialogManager` usage of this
* Increased test coverage
* BREAKING: Removed unnecessary factories 

## 1.1.0

* Fixed typos
* Refactored project structure
* `Agents` renamed to `Managers`
* Added `BlockAndroidBackButtonMixin` and `SingleAutoDisposalControllerMixin` with tests
* Reworked inserting/removing dialogs in overlay
* Provided tests on insert/remove strategies

## 1.0.8

* Fixed typos
* Removed auto opacity apply to provided color (FullScreenBlur)
* FullScreen renamed to EasyFullScreen and is public now
* Transitions are public now
* Removed default modal banner color
* BREAKING: Reworked `CustomAgents` API

## 1.0.7

* Fixed case, when overlay entry was not removed
## 1.0.6

* Fixed modal banner decoration and some typos

## 1.0.5

* Removed pointless assert for dismissible callback

## 1.0.4

* Updated description

## 1.0.3

* Fixed not specified showBanner params (padding, margin, backgroundColor, borderRadius)

## 1.0.2

* Removed typo in folder name. Updated readme
## 1.0.1

* Updated readme

## 1.0.0

* BREAKING: FlutterEasyDialogs.of(context) method for getting dialogsController replaced with static get method based on GlobalKey. EasyDialogsController is now available in any place of the app.
## 0.0.2

* Description changed

## 0.0.1

* Initial release
