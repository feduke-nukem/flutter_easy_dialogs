import 'package:flutter_easy_dialogs/src/core/dialogs/easy_dialog_position.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/easy_dialog_type.dart';

class EasyOverlayEntryProperties {
  final EasyDialogPosition dialogPosition;
  final EasyDialogType dialogType;

  const EasyOverlayEntryProperties({
    required this.dialogPosition,
    required this.dialogType,
  });

  factory EasyOverlayEntryProperties.other() {
    return const EasyOverlayEntryProperties(
      dialogPosition: EasyDialogPosition.other,
      dialogType: EasyDialogType.other,
    );
  }

  @override
  bool operator ==(Object? other) {
    if (identical(this, other)) return true;

    return runtimeType == other.runtimeType &&
        other is EasyOverlayEntryProperties &&
        dialogPosition == other.dialogPosition &&
        dialogType == other.dialogType;
  }

  @override
  int get hashCode {
    final values = [
      dialogPosition,
      dialogType,
    ];

    return Object.hashAll(values);
  }
}
