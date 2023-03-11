
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

/// For disabling back button on Android
mixin BlockAndroidBackButtonMixin<S, H> on EasyDialogManagerBase<S, H> {
  bool _backButtonInterceptor(
    bool stopDefaultButtonEvent,
    RouteInfo routeInfo,
  ) =>
      true;

  /// Starts blocking Android back button events
  void blockBackButton() => BackButtonInterceptor.add(_backButtonInterceptor);

  /// Stops blocking Android back button events
  void unblockBackButton() =>
      BackButtonInterceptor.remove(_backButtonInterceptor);
}
