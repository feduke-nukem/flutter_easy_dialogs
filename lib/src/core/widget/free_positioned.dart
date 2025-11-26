import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/positioned/positioned.dart'
    show PositionedDialog;

class FreePositioned extends StatefulWidget {
  final Widget child;
  final Rect? bounds;

  const FreePositioned({
    required this.child,
    this.bounds,
    super.key,
  });

  @override
  State<FreePositioned> createState() => _FreePositionedState();
}

class _FreePositionedState extends State<FreePositioned> {
  var _offset = Offset(0.0, 0.0);
  Offset? _globalOffset;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    final result = Builder(
      builder: (context) => GestureDetector(
        child: widget.child,
        onPanStart: (details) => _onPanStart(details, context),
        onPanUpdate: (details) => _onPanUpdate(details, context),
      ),
    );

    final alignment = PositionedDialog.maybeOf(context)?.alignment;

    return Stack(
      children: [
        Positioned(
          left: _offset.dx,
          top: _offset.dy,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenSize.width,
              maxHeight: screenSize.height,
            ),
            child: alignment == null
                ? result
                : Align(
                    alignment: alignment,
                    child: result,
                  ),
          ),
        ),
      ],
    );
  }

  void _onPanStart(DragStartDetails details, BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    _globalOffset = renderBox.localToGlobal(Offset.zero);
  }

  void _onPanUpdate(DragUpdateDetails details, BuildContext context) {
    final globalOffset = _globalOffset;

    if (globalOffset == null) {
      return;
    }

    final deltaX = details.delta.dx;
    final deltaY = details.delta.dy;
    final newGlobalX = globalOffset.dx + deltaX;
    final newGlobalY = globalOffset.dy + deltaY;
    final oldOffset = _offset;

    final bounds = widget.bounds;

    if (bounds == null) {
      setState(() {
        _offset = Offset(_offset.dx + deltaX, _offset.dy + deltaY);
        _globalOffset = Offset(newGlobalX, newGlobalY);
      });

      return;
    }

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      return;
    }

    final childSize = renderBox.size;

    final inBoundsX = newGlobalX >= bounds.left &&
        newGlobalX + childSize.width <= bounds.right;
    final inBoundsY = newGlobalY >= bounds.top &&
        newGlobalY + childSize.height <= bounds.bottom;

    if (inBoundsX) {
      _offset = Offset(_offset.dx + deltaX, _offset.dy);
      _globalOffset = Offset(newGlobalX, newGlobalY);
    }

    if (inBoundsY) {
      _offset = Offset(_offset.dx, _offset.dy + deltaY);
      _globalOffset = Offset(newGlobalX, newGlobalY);
    }

    if (oldOffset == _offset) {
      return;
    }

    setState(() {});
  }
}
