import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/agents/dialog_agent_base.dart';

class BannerDismissParams extends DismissParams {
  final EasyDialogPosition position;
  final bool dismissAll;

  const BannerDismissParams({
    required super.overlayController,
    required this.dismissAll,
    required this.position,
  });
}
