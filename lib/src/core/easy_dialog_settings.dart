import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialog_type.dart';

class EasyDialogSettings {
  final EasyDialogPosition position;
  final EasyDialogType type;

  const EasyDialogSettings({
    required this.position,
    required this.type,
  });

  factory EasyDialogSettings.other() {
    return const EasyDialogSettings(
      position: EasyDialogPosition.other,
      type: EasyDialogType.other,
    );
  }

  @override
  bool operator ==(Object? other) {
    if (identical(this, other)) return true;

    return runtimeType == other.runtimeType &&
        other is EasyDialogSettings &&
        position == other.position &&
        type == other.type;
  }

  @override
  int get hashCode {
    final values = [
      position,
      type,
    ];

    return Object.hashAll(values);
  }
}
