library bitsdojo_window_windows;

import './native_api.dart';
import './window.dart';

const notInitializedMessage = """
 bitsdojo_window is not initalized.
 """;

class BitsDojoNotInitializedException implements Exception {
  String errMsg() => notInitializedMessage;
}

class GtkAppWindow extends GtkWindow {
  GtkAppWindow._() {
    super.handle = getFlutterWindow();
    AppState state = getAppState();
    if (state == AppState.Unknown) {
      print(notInitializedMessage);
      throw BitsDojoNotInitializedException;
    }
    assert(handle != null, "Could not get Flutter window");
  }

  static final GtkAppWindow _instance = GtkAppWindow._();

  factory GtkAppWindow() {
    return _instance;
  }
}
