library bitsdojo_window_linux;

import 'dart:ffi';

final DynamicLibrary _appExecutable = DynamicLibrary.executable();

final getFlutterWindow =
    _appExecutable.lookupFunction<IntPtr Function(), int Function()>(
        "bitsdojo_window_getFlutterWindow");

final getFlutterGdkWindow =
    _appExecutable.lookupFunction<IntPtr Function(), int Function()>(
        "bitsdojo_window_getFlutterGdkWindow");

final setMinSize = _appExecutable.lookupFunction<
    Void Function(Int32 width, Int32 height),
    void Function(int width, int height)>("bitsdojo_window_setMinSize");

final setMaxSize = _appExecutable.lookupFunction<
    Void Function(Int32 width, Int32 height),
    void Function(int width, int height)>("bitsdojo_window_setMaxSize");
