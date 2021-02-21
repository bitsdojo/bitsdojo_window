import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'dart:io' show Platform;

class WindowBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double width;

  WindowBorder({Key key, this.child, @required this.color, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Don't show border on macOS
    if (!kIsWeb) {
      if (Platform.isMacOS) {
        return child;
      }
    }
    return Container(
      child: child,
      decoration: BoxDecoration(
          border: Border.all(color: this.color, width: width ?? 1)),
    );
  }
}
