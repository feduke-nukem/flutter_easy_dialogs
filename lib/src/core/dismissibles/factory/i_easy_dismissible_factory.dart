import 'package:flutter_easy_dialogs/src/core/dismissibles/easy_dismissible.dart';

/// Interface of factory for creating [IEasyDismissor]
abstract class IEasyDismissibleFactory {
  /// Create dismissible method using [DismissibleCreateParams] params
  IEasyDismissor createDismissible(covariant DismissibleCreateParams params);
}

/// Core dto class of [IEasyDismissibleFactory] createDismissible method params
class DismissibleCreateParams {
  final EasyDismissCallback onDismissed;

  /// Creates an instance of [DismissibleCreateParams]
  const DismissibleCreateParams({
    required this.onDismissed,
  });
}
