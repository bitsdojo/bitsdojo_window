library bitsdojo_window_macos;

import 'package:bitsdojo_window_macos/src/window.dart';
import './native_api.dart';

class MacAppWindow extends MacOSWindow {
  MacAppWindow._() {
    super.handle = getAppWindow();
    print("getAppWindow returned $handle");
    if (handle == null) {
      print("Could not get Flutter window");
    }
  }

  static final MacAppWindow _instance = MacAppWindow._();

  factory MacAppWindow() {
    return _instance;
  }
}
