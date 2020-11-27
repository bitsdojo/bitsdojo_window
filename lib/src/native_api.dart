library bitsdojo_window;

import 'dart:ffi';

final DynamicLibrary _appExecutable = DynamicLibrary.executable();

final _getAppState = _appExecutable
    .lookupFunction<Uint8 Function(), int Function()>("getAppState");

enum AppState { Unknown, Starting, Ready }

extension AppStateValue on AppState {
  int get value {
    switch (this) {
      case AppState.Unknown:
        return 0;
      case AppState.Starting:
        return 1;
      case AppState.Ready:
        return 2;
    }
    return null;
  }
}

AppState getAppState() {
  return AppState.values[_getAppState()];
}

final _setAppState = _appExecutable
    .lookupFunction<Void Function(Uint8), void Function(int)>("setAppState");

void setAppState(AppState newState) {
  _setAppState(newState.value);
}

final getFlutterWindow = _appExecutable
    .lookupFunction<IntPtr Function(), int Function()>("getFlutterWindow");

final setMinSize = _appExecutable.lookupFunction<
    Void Function(Int32 width, Int32 height),
    void Function(int width, int height)>("setMinSize");

final setMaxSize = _appExecutable.lookupFunction<
    Void Function(Int32 width, Int32 height),
    void Function(int width, int height)>("setMaxSize");
