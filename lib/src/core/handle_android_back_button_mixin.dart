import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

// https://github.com/dart-lang/sdk/issues/39779
// coverage:ignore-file
/// For handling back button on Android.

mixin HandleAndroidBackButtonMixin on EasyDialogLifecycle {
  WillPopCallback? get willPop;

  @override
  void onShow() {
    super.onShow();

    _AndroidBackButtonHandler.blockBackButton(_onPop);
  }

  @override
  void onHide() {
    super.onHide();

    _AndroidBackButtonHandler.unblockBackButton(_onPop);
  }

  @protected
  void onPop() {}

  Future<void> _onPop() async {
    if (willPop == null) return;

    final canPop = await willPop!();

    if (!canPop) return;

    onPop();
  }
}

abstract class _AndroidBackButtonHandler implements WidgetsBinding {
  static bool _isBlocked = false;

  static final _callBacks = <AsyncCallback>[];

  /// Starts blocking Android back button events.
  static void blockBackButton(AsyncCallback? onPop) {
    if (onPop != null) _callBacks.add(onPop);
    SystemChannels.navigation.setMethodCallHandler(_handleNavigationInvocation);
    _isBlocked = true;
  }

  static void unblockBackButton(AsyncCallback? onPop) {
    if (onPop != null) _callBacks.remove(onPop);
    _isBlocked = false;
  }

  static Future _handleNavigationInvocation(MethodCall methodCall) {
    if (methodCall.method == 'popRoute') {
      for (final callBack in _callBacks) {
        callBack();
      }

      return _isBlocked
          ? Future.value()
          : WidgetsBinding.instance.handlePopRoute();
    }

    if (methodCall.method == 'pushRoute') {
      return WidgetsBinding.instance.handlePushRoute(methodCall.arguments);
    }

    return Future.value();
  }
}
