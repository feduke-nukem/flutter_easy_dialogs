import 'package:flutter/widgets.dart';

class FreePositioned extends StatefulWidget {
  final Widget child;

  const FreePositioned({required this.child});

  @override
  State<FreePositioned> createState() => _FreePositionedState();
}

class _FreePositionedState extends State<FreePositioned> {
  var _x = 0.0;
  var _y = 0.0;
  AlignmentGeometry? _alignment;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        Positioned(
          left: _x,
          top: _y,
          child: GestureDetector(
            onPanUpdate: (details) => setState(
              () {
                _x += details.delta.dx;
                _y += details.delta.dy;
              },
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenSize.width,
                maxHeight: screenSize.height,
              ),
              // Not the best approach to apply alignment but it works for now,
              // need to be reworked in the future
              child: _alignment == null
                  ? widget.child
                  : Align(
                      alignment: _alignment!,
                      child: widget.child,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _alignment = context.findAncestorWidgetOfExactType<Align>()?.alignment;
  }
}
