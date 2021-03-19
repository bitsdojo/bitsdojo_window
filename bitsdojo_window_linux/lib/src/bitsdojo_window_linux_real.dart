library bitsdojo_window_linux;

import 'dart:ui';
import 'package:bitsdojo_window_platform_interface/bitsdojo_window_platform_interface.dart';

import './app_window.dart';
import 'package:flutter/widgets.dart';

class BitsdojoWindowLinux extends BitsdojoWindowPlatform {
  BitsdojoWindowLinux() : super();

  @override
  void doWhenWindowReady(VoidCallback callback) {
    WidgetsBinding.instance!.waitUntilFirstFrameRasterized.then((value) {
      callback();
    });
  }

  @override
  DesktopWindow get appWindow {
    return GtkAppWindow();
  }
}
