import 'package:bitsdojo_window_platform_interface_v3/bitsdojo_window_platform_interface_v3.dart';
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
