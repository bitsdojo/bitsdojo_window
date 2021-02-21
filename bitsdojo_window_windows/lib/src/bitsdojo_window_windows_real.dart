library bitsdojo_window_windows;

import 'dart:ui';
import 'package:bitsdojo_window_platform_interface/bitsdojo_window_platform_interface.dart';

import './app_window.dart';
import 'package:flutter/widgets.dart';
import './native_api.dart';

class BitsdojoWindowWindows extends BitsdojoWindowPlatform {
  BitsdojoWindowWindows() : super();

  @override
  void doWhenWindowReady(VoidCallback callback) {
    WidgetsBinding.instance.waitUntilFirstFrameRasterized.then((value) {
      setAppState(AppState.Ready);
      callback();
    });
  }

  @override
  DesktopWindow get appWindow {
    return WinAppWindow();
  }
}
