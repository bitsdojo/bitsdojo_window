import 'package:flutter/widgets.dart';

class WindowBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double width;

  WindowBorder({Key key, this.child, @required this.color, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      decoration: BoxDecoration(
          border: Border.all(color: this.color, width: width ?? 1)),
    );
  }
}
