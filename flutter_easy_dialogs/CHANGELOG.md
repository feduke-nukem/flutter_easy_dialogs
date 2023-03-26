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
