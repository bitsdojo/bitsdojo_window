library bitsdojo_window_macos_v3;

import './window.dart';
import './native_api.dart';

class MacAppWindow extends MacOSWindow {
  MacAppWindow._() {
    super.handle = getAppWindow();
    if (handle == null) {
      print("Could not get Flutter window");
    }
  }

  static final MacAppWindow _instance = MacAppWindow._();

  factory MacAppWindow() {
    return _instance;
  }
}
