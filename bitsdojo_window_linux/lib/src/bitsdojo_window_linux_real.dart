library bitsdojo_window_linux;

import 'dart:ui';
import 'package:bitsdojo_window_platform_interface/bitsdojo_window_platform_interface.dart';

import './app_window.dart';
import 'package:flutter/widgets.dart';
import './native_api.dart';

class BitsdojoWindowLinux extends BitsdojoWindowPlatform {
  BitsdojoWindowLinux() : super();

  @override
  void doWhenWindowReady(VoidCallback callback) {
    WidgetsBinding.instance.waitUntilFirstFrameRasterized.then((value) {
      setAppState(AppState.Ready);
      callback();
    });
  }

  @override
  DesktopWindow get appWindow {
    return GtkAppWindow();
  }
}
