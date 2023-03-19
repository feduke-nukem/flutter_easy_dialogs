part of 'positioned_manager.dart';

class _DialogsMap {
  final Map<EasyDialogPosition, AnimationController> _map = {};

  AnimationController? getController(EasyDialogPosition position) {
    return _map[position];
  }

  void addController(
    EasyDialogPosition position,
    AnimationController controller,
  ) {
    _map[position] = controller;
  }

  void removeController(EasyDialogPosition position) {
    _map.remove(position);
  }

  bool get isEmpty => _map.isEmpty;

  bool get isNotEmpty => _map.isNotEmpty;

  void clear() => _map.clear();

  Iterable<MapEntry<EasyDialogPosition, AnimationController>> get entries =>
      _map.entries;
}
