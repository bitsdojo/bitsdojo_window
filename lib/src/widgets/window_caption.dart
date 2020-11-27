import 'package:flutter/widgets.dart';
import '../plugin_channel.dart';
import '../app_window.dart';
import '../win32_plus.dart';
import 'package:win32/win32.dart';

double getTitleBarHeight() {
  double result = GetSystemMetrics(SM_CYCAPTION).toDouble();
  return result;
}

Size getTitleBarButtonSize() {
  double width = GetSystemMetrics(SM_CXSIZE).toDouble();
  double height = GetSystemMetrics(SM_CYSIZE).toDouble();
  return Size(width, height);
}

void dragAppWindow() async {
  try {
    await bitsDojoWindowChannel.invokeMethod('dragAppWindow');
  } catch (e) {
    print("Could not start draggging -> ${e.message}");
  }
}

class _MoveWindow extends StatelessWidget {
  _MoveWindow({Key key, this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: (details) {
          dragAppWindow();
        },
        onDoubleTap: () => appWindow.maximizeOrRestore(),
        child: this.child ?? Container());
  }
}

class MoveWindow extends StatelessWidget {
  final Widget child;
  MoveWindow({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (child == null) return _MoveWindow();
    return _MoveWindow(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Expanded(child: this.child)]),
    );
  }
}

class WindowTitleBarBox extends StatelessWidget {
  final Widget child;
  WindowTitleBarBox({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var titlebarHeight = getTitleBarHeight();
    return SizedBox(height: titlebarHeight, child: this.child ?? Container());
  }
}
