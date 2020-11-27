library bitsdojo_window;

import 'package:flutter/widgets.dart';
import './native_api.dart';
import './window.dart';

void doWhenWindowReady(VoidCallback callback) {
  WidgetsBinding.instance.waitUntilFirstFrameRasterized.then((value) {
    setAppState(AppState.Ready);
    callback();
  });
}

var appWindow = AppWindow();
const notInitializedMessage = """
 bitsdojo_window is not initalized.  
 """;

class BitsDojoNotInitializedException implements Exception {
  String errMsg() => notInitializedMessage;
}

class AppWindow extends Window {
  AppWindow._() {
    super.handle = getFlutterWindow();
    AppState state = getAppState();
    if (state == AppState.Unknown) {
      print(notInitializedMessage);
      throw BitsDojoNotInitializedException;
    }
    if (handle == null) {
      print("Could not get Flutter window");
    }
  }

  static final AppWindow _instance = AppWindow._();

  factory AppWindow() {
    return _instance;
  }
}
