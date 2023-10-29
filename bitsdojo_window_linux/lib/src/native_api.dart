library bitsdojo_window_linux;

import 'dart:ffi';
import 'package:ffi/ffi.dart';

final DynamicLibrary _appExecutable = DynamicLibrary.executable();

// getAppWindowHandle
typedef IntPtr TGetAppWindowHandle();
typedef DGetAppWindowHandle = int Function();
final DGetAppWindowHandle getAppWindowHandle =
    _theAPI.ref.getAppWindowHandle.asFunction();

// getScreenRect
typedef Void TGetScreenRect(IntPtr window, Pointer<Int32> x, Pointer<Int32> y,
    Pointer<Int32> width, Pointer<Int32> height);
typedef DGetScreenRect = void Function(int window, Pointer<Int32> x,
    Pointer<Int32> y, Pointer<Int32> width, Pointer<Int32> height);
final DGetScreenRect getScreenRect = _theAPI.ref.getScreenRect.asFunction();

// getScaleFactor
typedef Void TGetScaleFactor(IntPtr window, Pointer<Int32> scaleFactor);
typedef DGetScaleFactor = void Function(int window, Pointer<Int32> scaleFactor);
final DGetScaleFactor getScaleFactor = _theAPI.ref.getScaleFactor.asFunction();

// getPosition
typedef Void TGetPosition(IntPtr window, Pointer<Int32> x, Pointer<Int32> y);
typedef DGetPosition = void Function(
    int window, Pointer<Int32> x, Pointer<Int32> y);
final DGetPosition getPosition = _theAPI.ref.getPosition.asFunction();

// setPosition
typedef Void TSetPosition(IntPtr window, Int32 x, Int32 y);
typedef DSetPosition = void Function(int window, int x, int y);
final DSetPosition setPosition = _theAPI.ref.setPosition.asFunction();

// getSize
typedef Void TGetSize(
    IntPtr window, Pointer<Int32> width, Pointer<Int32> height);
typedef DGetSize = void Function(
    int window, Pointer<Int32> width, Pointer<Int32> height);
final DGetSize getSize = _theAPI.ref.getSize.asFunction();

// setSize
typedef Void TSetSize(IntPtr window, Int32 width, Int32 height);
typedef DSetSize = void Function(int window, int width, int height);
final DSetSize setSize = _theAPI.ref.setSize.asFunction();
// setRect
typedef Void TSetRect(
    IntPtr window, Int32 x, Int32 y, Int32 width, Int32 height);
typedef DSetRect = void Function(
    int window, int x, int y, int width, int height);
final DSetRect setRect = _theAPI.ref.setRect.asFunction();

// setMinSize
typedef Void TSetMinSize(IntPtr window, Int32 width, Int32 height);
typedef DSetMinSize = void Function(int window, int width, int height);
final DSetMinSize setMinSize = _theAPI.ref.setMinSize.asFunction();

// setMaxSize
typedef Void TSetMaxSize(IntPtr window, Int32 width, Int32 height);
typedef DSetMaxSize = void Function(int window, int width, int height);
final DSetMinSize setMaxSize = _theAPI.ref.setMaxSize.asFunction();

// showWindow
typedef Void TShowWindow(IntPtr window);
typedef DShowWindow = void Function(int window);
final DShowWindow showWindow = _theAPI.ref.showWindow.asFunction();

// hideWindow
typedef Void THideWindow(IntPtr window);
typedef DHideWindow = void Function(int window);
final DHideWindow hideWindow = _theAPI.ref.hideWindow.asFunction();

// maximizeWindow
typedef Void TMinimizeWindow(IntPtr window);
typedef DMinimizeWindow = void Function(int window);
final DMinimizeWindow minimizeWindow = _theAPI.ref.minimizeWindow.asFunction();

// maximizeWindow
typedef Void TMaximizeWindow(IntPtr window);
typedef DMaximizeWindow = void Function(int window);
final DMaximizeWindow maximizeWindow = _theAPI.ref.maximizeWindow.asFunction();

// unmaximizeWindow
typedef Void TUnmaximizeWindow(IntPtr window);
typedef DUnmaximizeWindow = void Function(int window);
final DMaximizeWindow unmaximizeWindow =
    _theAPI.ref.unmaximizeWindow.asFunction();

// setWindowTitle
typedef Void TSetWindowTitle(IntPtr window, Pointer<Utf8> title);
typedef DSetWindowTitle = void Function(int window, Pointer<Utf8> title);
final DSetWindowTitle setWindowTitle = _theAPI.ref.setWindowTitle.asFunction();

sealed class BDWAPI extends Struct {
  external Pointer<NativeFunction<TGetAppWindowHandle>> getAppWindowHandle;
  external Pointer<NativeFunction<TGetScreenRect>> getScreenRect;
  external Pointer<NativeFunction<TGetScaleFactor>> getScaleFactor;
  external Pointer<NativeFunction<TGetPosition>> getPosition;
  external Pointer<NativeFunction<TSetPosition>> setPosition;
  external Pointer<NativeFunction<TGetSize>> getSize;
  external Pointer<NativeFunction<TSetSize>> setSize;
  external Pointer<NativeFunction<TSetRect>> setRect;
  external Pointer<NativeFunction<TSetMinSize>> setMinSize;
  external Pointer<NativeFunction<TSetMaxSize>> setMaxSize;
  external Pointer<NativeFunction<TShowWindow>> showWindow;
  external Pointer<NativeFunction<THideWindow>> hideWindow;
  external Pointer<NativeFunction<TMinimizeWindow>> minimizeWindow;
  external Pointer<NativeFunction<TMaximizeWindow>> maximizeWindow;
  external Pointer<NativeFunction<TUnmaximizeWindow>> unmaximizeWindow;
  external Pointer<NativeFunction<TSetWindowTitle>> setWindowTitle;
}

typedef Pointer<BDWAPI> TBitsdojoWindowAPI();

final TBitsdojoWindowAPI bitsdojoWindowAPI = _appExecutable
    .lookup<NativeFunction<TBitsdojoWindowAPI>>("bitsdojo_window_api")
    .asFunction();

final Pointer<BDWAPI> _theAPI = bitsdojoWindowAPI();
