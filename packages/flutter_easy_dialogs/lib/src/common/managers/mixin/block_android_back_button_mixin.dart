import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';

// https://github.com/dart-lang/sdk/issues/39779
// coverage:ignore-file
/// For disabling back button on Android.
mixin BlockAndroidBackButtonMixin<S extends EasyDialogManagerShowParams?,
    H extends EasyDialogManagerHideParams?> on EasyDialogManager<S, H> {
  bool _backButtonInterceptor(
    bool stopDefaultButtonEvent,
    RouteInfo routeInfo,
  ) =>
      true;

  /// Starts blocking Android back button events.
  void blockBackButton() => BackButtonInterceptor.add(_backButtonInterceptor);

  /// Stops blocking Android back button events.
  void unblockBackButton() =>
      BackButtonInterceptor.remove(_backButtonInterceptor);
}
