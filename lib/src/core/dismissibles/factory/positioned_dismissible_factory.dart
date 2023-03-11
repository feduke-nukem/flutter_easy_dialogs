import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/dismissibles/factory/i_easy_dismissible_factory.dart';
import 'package:flutter_easy_dialogs/src/core/flutter_easy_dialogs_error.dart';

/// Positioned dismissible factory
class PositionedDismissibleFactory implements IEasyDismissibleFactory {
  @override
  EasyDismissible createDismissible(PositionedDismissibleCreateParams params) {
    switch (params.dismissibleType) {
      case EasyPositionedDismissibleType.swipe:
        return EasySwipeDismissible(
          onDismissed: params.onDismissed,
        );

      case EasyPositionedDismissibleType.tap:
        return EasyTapDismissible(onDismissed: params.onDismissed);
      default:
        Error.throwWithStackTrace(
          FlutterEasyDialogsError(
            message: 'no case for ${params.dismissibleType}',
          ),
          StackTrace.current,
        );
    }
  }
}

/// Positioned dismissible create params data class
class PositionedDismissibleCreateParams extends DismissibleCreateParams {
  /// Dismissible type
  final EasyPositionedDismissibleType dismissibleType;

  /// Creates an instance of [PositionedDismissibleCreateParams]
  const PositionedDismissibleCreateParams({
    required super.onDismissed,
    required this.dismissibleType,
  });
}
