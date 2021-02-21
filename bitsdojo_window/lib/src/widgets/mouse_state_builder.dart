import 'package:flutter/widgets.dart';

typedef MouseStateBuilderCB = Widget Function(
    BuildContext context, MouseState mouseState);

class MouseState {
  bool isMouseOver;
  bool isMouseDown;
  MouseState() {
    this.isMouseDown = false;
    this.isMouseOver = false;
  }
  @override
  String toString() {
    return "isMouseDown: ${this.isMouseDown} - isMouseOver: ${this.isMouseOver}";
  }
}

class MouseStateBuilder extends StatefulWidget {
  final MouseStateBuilderCB builder;
  final VoidCallback onPressed;
  MouseStateBuilder({Key key, @required this.builder, this.onPressed})
      : assert(builder != null),
        super(key: key);
  @override
  _MouseStateBuilderState createState() => _MouseStateBuilderState();
}

class _MouseStateBuilderState extends State<MouseStateBuilder> {
  MouseState _mouseState;
  _MouseStateBuilderState() {
    _mouseState = MouseState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (event) {
          setState(() {
            _mouseState.isMouseOver = true;
          });
        },
        onExit: (event) {
          setState(() {
            _mouseState.isMouseOver = false;
          });
        },
        child: GestureDetector(
            onTapDown: (_) {
              setState(() {
                _mouseState.isMouseDown = true;
              });
            },
            onTapCancel: () {
              setState(() {
                _mouseState.isMouseDown = false;
              });
            },
            onTap: () {
              setState(() {
                _mouseState.isMouseDown = false;
                _mouseState.isMouseOver = false;
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                widget.onPressed();
              });
            },
            onTapUp: (_) {},
            child: widget.builder(context, _mouseState)));
  }
}
