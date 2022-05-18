library bitsdojo_window_windows;

import 'package:flutter/widgets.dart';
import 'package:bitsdojo_window_platform_interface/bitsdojo_window_platform_interface.dart';
import './window.dart';
import './app_window.dart';
import './native_api.dart';

export './window_interface.dart';

T? _ambiguate<T>(T? value) => value;

class BitsdojoWindowWindows extends BitsdojoWindowPlatform {
  BitsdojoWindowWindows() : super();

  @override
  void doWhenWindowReady(VoidCallback callback) {
    _ambiguate(WidgetsBinding.instance)!
        .waitUntilFirstFrameRasterized
        .then((value) {
      isInsideDoWhenWindowReady = true;
      setWindowCanBeShown(true);
      callback();
      isInsideDoWhenWindowReady = false;
    });
  }

  @override
  DesktopWindow get appWindow {
    return WinAppWindow();
  }
}
