import 'package:flutter/widgets.dart';
import 'package:flutter_easy_dialogs/src/core/dismissibles/easy_dismissible.dart';

class EasySwipeDismissible extends EasyDismissible {
  EasySwipeDismissible({
    required super.onDismissed,
  });

  @override
  Widget makeDismissible(Widget child) {
    return Dismissible(
      key: UniqueKey(),
      behavior: HitTestBehavior.deferToChild,
      onDismissed: (_) => super.onDismissed(),
      child: child,
    );
  }
}
