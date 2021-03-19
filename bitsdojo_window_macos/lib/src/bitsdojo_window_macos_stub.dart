import 'package:bitsdojo_window_platform_interface/bitsdojo_window_platform_interface.dart';
import 'dart:ui';

class BitsdojoWindowMacOS extends BitsdojoWindowPlatform {
  BitsdojoWindowMacOS() {
    assert(false);
  }

  @override
  void doWhenWindowReady(VoidCallback callback) {}

  @override
  DesktopWindow get appWindow {
    return AppWindowNotImplemented();
  }
}
