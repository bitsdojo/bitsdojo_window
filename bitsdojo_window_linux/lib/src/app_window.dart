library bitsdojo_window_linux;

import './native_api.dart' as native;
import './window.dart';

const notInitializedMessage = """
 bitsdojo_window is not initalized.
 """;

class BitsDojoNotInitializedException implements Exception {
  String errMsg() => notInitializedMessage;
}

class GtkAppWindow extends GtkWindow {
  GtkAppWindow._() {
    super.handle = native.getAppWindowHandle();
    assert(handle != null, "Could not get Flutter window");
  }

  static final GtkAppWindow _instance = GtkAppWindow._();

  factory GtkAppWindow() {
    return _instance;
  }
}
