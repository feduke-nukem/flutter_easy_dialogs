import 'package:flutter_easy_dialogs/src/core/dismissibles/easy_dismissible.dart';
import 'package:flutter_easy_dialogs/src/core/dismissibles/factory/i_easy_dismissible_factory.dart';
import 'package:flutter_easy_dialogs/src/core/dismissibles/pre_built/easy_swipe_dismissible.dart';
import 'package:flutter_easy_dialogs/src/core/dismissibles/pre_built/easy_tap_dismissble.dart';
import 'package:flutter_easy_dialogs/src/core/dismissibles/types/easy_positioned_dismissible_type.dart';
import 'package:flutter_easy_dialogs/src/core/flutter_easy_dialogs_exception.dart';

class PositionedDismissibleFactory implements IEasyDismissibleFactory {
  @override
  EasyDismissible createDismissible(DismissibleCreateParams params) {
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
