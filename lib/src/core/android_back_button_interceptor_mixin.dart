import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

// https://github.com/dart-lang/sdk/issues/39779
// coverage:ignore-file
/// For handling back button on Android.

mixin AndroidBackButtonInterceptorMixin on EasyDialogLifecycle {
  WillPopCallback? get androidWillPop;

  @override
  void init() {
    super.init();
    _AndroidBackButtonInterceptor.addCallback(onAndroidPop);
  }

  @override
  void onShow() {
    super.onShow();

    _AndroidBackButtonInterceptor.blockBackButton();
  }

  @override
  void onHidden() {
    super.onHidden();

    _AndroidBackButtonInterceptor.unblockBackButton();
  }

  @override
  void dispose() {
    _AndroidBackButtonInterceptor.removeCallback(onAndroidPop);
    super.dispose();
  }

  @protected
  void onAndroidPop() {}
}

abstract class _AndroidBackButtonInterceptor implements WidgetsBinding {
  static bool _isBlocked = false;
  static bool _isMethodCallHandlerSet = false;

  static final _callBacks = <VoidCallback>[];

  static void addCallback(VoidCallback callback) {
    _callBacks.add(callback);
  }

  static void removeCallback(VoidCallback callback) {
    _callBacks.remove(callback);
  }

  /// Starts blocking Android back button events.
  static void blockBackButton() {
    if (!_isMethodCallHandlerSet) {
      SystemChannels.navigation
          .setMethodCallHandler(_handleNavigationInvocation);
      _isMethodCallHandlerSet = true;
    }
    _isBlocked = true;
  }

  static void unblockBackButton() {
    _isBlocked = false;
  }

  static Future _handleNavigationInvocation(MethodCall methodCall) {
    if (methodCall.method == 'popRoute') {
      _callBacks.forEach((callback) => callback());

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
