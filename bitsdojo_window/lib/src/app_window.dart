import 'dart:ui';
import 'package:bitsdojo_window/src/other_platform.dart';
import 'package:bitsdojo_window_platform_interface/bitsdojo_window_platform_interface.dart';
import 'package:bitsdojo_window_platform_interface/method_channel_bitsdojo_window.dart';
import 'package:bitsdojo_window_windows/bitsdojo_window_windows.dart';
import 'package:bitsdojo_window_macos/bitsdojo_window_macos.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:io' show Platform;

bool _platformInstanceNeedsInit = true;

void initPlatformInstance() {
  if (!kIsWeb) {
    if (BitsdojoWindowPlatform.instance is MethodChannelBitsdojoWindow) {
      if (Platform.isWindows) {
        BitsdojoWindowPlatform.instance = BitsdojoWindowWindows();
      } else {
        if (Platform.isMacOS) {
          BitsdojoWindowPlatform.instance = BitsdojoWindowMacOS();
        }
      }
    }
  } else {
    BitsdojoWindowPlatform.instance = BitsdojoWindowOther();
  }
}

BitsdojoWindowPlatform get _platform {
  var needsInit = _platformInstanceNeedsInit;
  if (needsInit) {
    initPlatformInstance();
    _platformInstanceNeedsInit = false;
  }
  return BitsdojoWindowPlatform.instance;
}

void doWhenWindowReady(VoidCallback callback) {
  _platform.doWhenWindowReady(callback);
}

DesktopWindow get appWindow {
  return _platform.appWindow;
}
