library bitsdojo_window_macos_v3;

import 'package:bitsdojo_window_platform_interface_v3/bitsdojo_window_platform_interface_v3.dart';
import 'package:flutter/widgets.dart';
import './app_window.dart';
import './native_api.dart';

T? _ambiguate<T>(T? value) => value;

class BitsdojoWindowMacOS extends BitsdojoWindowPlatform {
  BitsdojoWindowMacOS() : super();

  @override
  void doWhenWindowReady(VoidCallback callback) {
    _ambiguate(WidgetsBinding.instance)!
        .waitUntilFirstFrameRasterized
        .then((value) {
      setWindowCanBeShown(true);
      setInsideDoWhenWindowReady(true);
      callback();
      setInsideDoWhenWindowReady(false);
    });
  }

  @override
  void dragAppWindow() async {
    print("We whould drag the window here");
  }

  @override
  DesktopWindow get appWindow {
    return MacAppWindow();
  }
}
