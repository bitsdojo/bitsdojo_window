library bitsdojo_window_windows_v3;

import './native_api.dart';
import './window.dart';

const notInitializedMessage = """
 bitsdojo_window is not initalized.  
 """;

class BitsDojoNotInitializedException implements Exception {
  String errMsg() => notInitializedMessage;
}

class WinAppWindow extends WinWindow {
  WinAppWindow._() {
    super.handle = getAppWindow();
    final isLoaded = isBitsdojoWindowLoaded();
    if (!isLoaded) {
      print(notInitializedMessage);
      throw BitsDojoNotInitializedException;
    }
    assert(handle != null, "Could not get Flutter window");
  }

  static final WinAppWindow _instance = WinAppWindow._();

  factory WinAppWindow() {
    return _instance;
  }
}
