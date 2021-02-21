library bitsdojo_window_macos;

import 'dart:ffi';

import 'package:bitsdojo_window_macos/src/native_struct.dart';

final DynamicLibrary _appExecutable = DynamicLibrary.executable();

const BDW_SUCCESS = 1;

// Native function types
typedef IntPtr NSWindowResultNative();
typedef Void NSWindowParamNative(IntPtr window);
typedef Void NSWindowIntx2ParamNative(IntPtr window, Int32 first, Int32 second);
typedef Void BoolParamNative(Int8 value);
typedef Int8 NSWindowRectParamNative(IntPtr window, Pointer<BDWRect> rect);

// Dart function types
typedef IntParamDart = void Function(int value);
typedef NSWindowResultDart = int Function();
typedef NSWindowParamDart = void Function(int window);
typedef NSWindowIntx2ParamDart = void Function(
    int window, int first, int second);
typedef NSWindowRectParamDart = int Function(int window, Pointer<BDWRect> rect);

class BDWPublicAPI extends Struct {
  Pointer<NativeFunction<NSWindowResultNative>> getAppWindow;
  Pointer<NativeFunction<BoolParamNative>> setIsWindowReady;
  Pointer<NativeFunction<NSWindowParamNative>> showWindow;
  Pointer<NativeFunction<NSWindowParamNative>> moveWindow;
  Pointer<NativeFunction<NSWindowIntx2ParamNative>> setSize;
  Pointer<NativeFunction<NSWindowIntx2ParamNative>> setMinSize;
  Pointer<NativeFunction<NSWindowRectParamNative>> getScreenRectForWindow;
  Pointer<NativeFunction<NSWindowRectParamNative>> setRectForWindow;
  Pointer<NativeFunction<NSWindowRectParamNative>> getRectForWindow;
  Pointer<NativeFunction<IsWindowMaximizedNative>> isWindowMaximized;
  Pointer<NativeFunction<NSWindowParamNative>> maximizeWindow;
}

class BDWAPI extends Struct {
  Pointer<BDWPublicAPI> publicAPI;
}

typedef Pointer<BDWAPI> BDWAPIFN();

final BDWAPIFN bitsdojoWindowAPI = _appExecutable
    .lookup<NativeFunction<BDWAPIFN>>("bitsdojo_window_api")
    .asFunction();

final Pointer<BDWPublicAPI> _publicAPI = bitsdojoWindowAPI().ref.publicAPI;

final NSWindowResultDart getAppWindow =
    _publicAPI.ref.getAppWindow.asFunction();

final IntParamDart _setIsWindowReady =
    _publicAPI.ref.setIsWindowReady.asFunction();
void setIsWindowReady(bool value) => _setIsWindowReady(value ? 1 : 0);

final NSWindowParamDart showWindow = _publicAPI.ref.showWindow.asFunction();
final NSWindowParamDart moveWindow = _publicAPI.ref.moveWindow.asFunction();
final NSWindowParamDart maximizeWindow =
    _publicAPI.ref.maximizeWindow.asFunction();

final NSWindowIntx2ParamDart setSize = _publicAPI.ref.setSize.asFunction();
final NSWindowIntx2ParamDart setMinSize =
    _publicAPI.ref.setMinSize.asFunction();
final NSWindowRectParamDart _getScreenRectForWindow =
    _publicAPI.ref.getScreenRectForWindow.asFunction();

typedef Int8 IsWindowMaximizedNative(IntPtr window);
typedef IsWindowMaximizedDart = int Function(int window);
final IsWindowMaximizedDart _isWindowMaximized =
    _publicAPI.ref.isWindowMaximized.asFunction();

bool isWindowMaximized(int window) =>
    _isWindowMaximized(window) == 1 ? true : false;

final NSWindowRectParamDart setRectForWindowNative =
    _publicAPI.ref.setRectForWindow.asFunction();

final NSWindowRectParamDart getRectForWindowNative =
    _publicAPI.ref.getRectForWindow.asFunction();

bool getScreenRectNative(int window, Pointer<BDWRect> rect) {
  int result = _getScreenRectForWindow(window, rect);
  return result == BDW_SUCCESS ? true : false;
}
