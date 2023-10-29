import 'package:bitsdojo_window_platform_interface_v3/bitsdojo_window_platform_interface_v3.dart';
import 'package:bitsdojo_window_platform_interface_v3/method_channel_bitsdojo_window.dart';
import 'package:bitsdojo_window_windows_v3/bitsdojo_window_windows_v3.dart';
import 'package:bitsdojo_window_macos_v3/bitsdojo_window_macos_v3.dart';
import 'package:bitsdojo_window_linux_v3/bitsdojo_window_linux_v3.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

bool _platformInstanceNeedsInit = true;

void initPlatformInstance() {
  if (!kIsWeb) {
    if (BitsdojoWindowPlatform.instance is MethodChannelBitsdojoWindow) {
      if (Platform.isWindows) {
        BitsdojoWindowPlatform.instance = BitsdojoWindowWindows();
      } else if (Platform.isMacOS) {
        BitsdojoWindowPlatform.instance = BitsdojoWindowMacOS();
      } else if (Platform.isLinux) {
        BitsdojoWindowPlatform.instance = BitsdojoWindowLinux();
      }
    }
  } else {
    BitsdojoWindowPlatform.instance = BitsdojoWindowPlatformNotImplemented();
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
