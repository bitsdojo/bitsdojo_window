library bitsdojo_window_linux;

import 'package:bitsdojo_window_platform_interface/bitsdojo_window_platform_interface.dart';
import './window.dart';
import './app_window.dart';
import 'package:flutter/widgets.dart';

T? _ambiguate<T>(T? value) => value;

class BitsdojoWindowLinux extends BitsdojoWindowPlatform {
  BitsdojoWindowLinux() : super();

  @override
  void doWhenWindowReady(VoidCallback callback) {
    _ambiguate(WidgetsBinding.instance)!
        .waitUntilFirstFrameRasterized
        .then((value) {
      isInsideDoWhenWindowReady = true;
      callback();
      isInsideDoWhenWindowReady = false;
    });
  }

  @override
  DesktopWindow get appWindow {
    return GtkAppWindow();
  }
}
