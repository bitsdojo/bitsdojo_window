library bitsdojo_window_linux;

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
    //TODO - implement this check
    /*final isLoaded = isBitsdojoWindowLoaded();
    if (!isLoaded) {
      print(notInitializedMessage);
      throw BitsDojoNotInitializedException;
    }*/
    assert(handle != null, "Could not get Flutter window");
  }

  static final GtkAppWindow _instance = GtkAppWindow._();

  factory GtkAppWindow() {
    return _instance;
  }
}
