import './native_api.dart';
import './gtk.dart';

int getWindowMonitor(int handle) {
  final screen = gtkWindowGetScreen(handle);
  final window = getFlutterGdkWindow();
  final display = gdkScreenGetDisplay(screen);
  final monitor = gdkDisplayGetMonitorAtWindow(display, window);
  return monitor;
}
