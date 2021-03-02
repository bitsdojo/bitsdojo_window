library bitsdojo_window_macos;

import 'dart:ffi';
import 'dart:ui';
import 'package:ffi/ffi.dart';
import './native_struct.dart';

final DynamicLibrary _appExecutable = DynamicLibrary.executable();

const BDW_SUCCESS = 1;

// Native function types

// First line - native function type definition
// Second line - dart function type definition
// Third line - dart function type instance

// getAppWindow
typedef IntPtr TGetAppWindow();
typedef DGetAppWindow = int Function();
final DGetAppWindow getAppWindow = _publicAPI.ref.getAppWindow.asFunction();

// setWindowCanBeShown
typedef Void TSetWindowCanBeShown(Int8 value);
typedef DSetWindowCanBeShown = void Function(int value);
final DSetWindowCanBeShown _setWindowCanBeShown =
    _publicAPI.ref.setWindowCanBeShown.asFunction();
void setWindowCanBeShown(bool value) => _setWindowCanBeShown(value ? 1 : 0);

// setInsideDoWhenWindowReady
typedef Void TSetInsideDoWhenWindowReady(Int8 value);
typedef DSetInsideDoWhenWindowReady = void Function(int value);
final DSetInsideDoWhenWindowReady _setInsideDoWhenWindowReady =
    _publicAPI.ref.setInsideDoWhenWindowReady.asFunction();
void setInsideDoWhenWindowReady(bool value) =>
    _setInsideDoWhenWindowReady(value ? 1 : 0);

// showWindow
typedef Void TShowWindow(IntPtr window);
typedef DShowWindow = void Function(int window);
final DShowWindow showWindow = _publicAPI.ref.showWindow.asFunction();

// hideWindow
typedef Void THideWindow(IntPtr window);
typedef DHideWindow = void Function(int window);
final DShowWindow hideWindow = _publicAPI.ref.hideWindow.asFunction();

// moveWindow
typedef Void TMoveWindow(IntPtr window);
typedef DMoveWindow = void Function(int window);
final DMoveWindow moveWindow = _publicAPI.ref.moveWindow.asFunction();

// setSize
typedef Void TSetSize(IntPtr window, Int32 first, Int32 second);
typedef DSetSize = void Function(int window, int first, int second);
final DSetSize setSize = _publicAPI.ref.setSize.asFunction();

// setMinSize
typedef Void TSetMinSize(IntPtr window, Int32 first, Int32 second);
typedef DSetMinSize = void Function(int window, int first, int second);
final DSetMinSize setMinSize = _publicAPI.ref.setMinSize.asFunction();

// setMaxSize
typedef Void TSetMaxSize(IntPtr window, Int32 first, Int32 second);
typedef DSetMaxSize = void Function(int window, int first, int second);
final DSetMinSize setMaxSize = _publicAPI.ref.setMaxSize.asFunction();

// getScreenInfoForWindow
typedef Int8 TGetScreenInfoForWindow(
    IntPtr window, Pointer<BDWScreenInfo> screenInfo);
typedef DGetScreenInfoForWindow = int Function(
    int window, Pointer<BDWScreenInfo> screenInfo);
final DGetScreenInfoForWindow _getScreenInfoForWindow =
    _publicAPI.ref.getScreenInfoForWindow.asFunction();

bool getScreenInfoNative(int window, Pointer<BDWScreenInfo> screenInfo) {
  int result = _getScreenInfoForWindow(window, screenInfo);
  return result == BDW_SUCCESS ? true : false;
}

// setPositionForWindow
typedef Int8 TSetPositionForWindow(IntPtr window, Pointer<BDWOffset> rect);
typedef DSetPositionForWindow = int Function(
    int window, Pointer<BDWOffset> rect);
final DSetPositionForWindow setPositionForWindowNative =
    _publicAPI.ref.setPositionForWindow.asFunction();

bool setPositionForWindow(int window, Offset offset) {
  final Pointer<BDWOffset> offsetPointer = newBDWOffset();
  offsetPointer.ref
    ..x = offset.dx
    ..y = offset.dy;
  int result = setPositionForWindowNative(window, offsetPointer);
  return result == BDW_SUCCESS ? true : false;
}

// setRectForWindow
typedef Int8 TSetRectForWindow(IntPtr window, Pointer<BDWRect> rect);
typedef DSetRectForWindow = int Function(int window, Pointer<BDWRect> rect);
final DSetRectForWindow setRectForWindowNative =
    _publicAPI.ref.setRectForWindow.asFunction();

// getRectForWindow
typedef Int8 TGetRectForWindow(IntPtr window, Pointer<BDWRect> rect);
typedef DGetRectForWindow = int Function(int window, Pointer<BDWRect> rect);
final DGetRectForWindow getRectForWindowNative =
    _publicAPI.ref.getRectForWindow.asFunction();

// isWindowVisibleπ
typedef Int8 TIsWindowVisible(IntPtr window);
typedef DIsWindowVisible = int Function(int window);
final DIsWindowVisible _isWindowVisible =
    _publicAPI.ref.isWindowVisible.asFunction();
bool isWindowVisible(int window) =>
    _isWindowVisible(window) == 1 ? true : false;

// isWindowMaximized
typedef Int8 TIsWindowMaximized(IntPtr window);
typedef DIsWindowMaximized = int Function(int window);
final DIsWindowMaximized _isWindowMaximized =
    _publicAPI.ref.isWindowMaximized.asFunction();
bool isWindowMaximized(int window) =>
    _isWindowMaximized(window) == 1 ? true : false;

// maximizeWindow
typedef Void TMaximizeOrRestoreWindow(IntPtr window);
typedef DMaximizeOrRestoreWindow = void Function(int window);
final DMaximizeOrRestoreWindow maximizeOrRestoreWindow =
    _publicAPI.ref.maximizeOrRestoreWindow.asFunction();

// maximizeWindow
typedef Void TMaximizeWindow(IntPtr window);
typedef DMaximizeWindow = void Function(int window);
final DMaximizeWindow maximizeWindow =
    _publicAPI.ref.maximizeWindow.asFunction();

// maximizeWindow
typedef Void TMinimizeWindow(IntPtr window);
typedef DMinimizeWindow = void Function(int window);
final DMinimizeWindow minimizeWindow =
    _publicAPI.ref.minimizeWindow.asFunction();

// closeWindow
typedef Void TCloseWindow(IntPtr window);
typedef DCloseWindow = void Function(int window);
final DMinimizeWindow closeWindow = _publicAPI.ref.closeWindow.asFunction();

// setWindowTitle
typedef Void TSetWindowTitle(IntPtr window, Pointer<Utf8> title);
typedef DSetWindowTitle = void Function(int window, Pointer<Utf8> title);
final DSetWindowTitle _setWindowTitle =
    _publicAPI.ref.setWindowTitle.asFunction();

void setWindowTitle(int window, String title) {
  final _title = title.toNativeUtf8();
  _setWindowTitle(window, _title);
  calloc.free(_title);
}

// getTitleBarHeight
typedef Double TGetTitleBarHeight(IntPtr window);
typedef DGetTitleBarHeight = double Function(int window);
final DGetTitleBarHeight getTitleBarHeight =
    _publicAPI.ref.getTitleBarHeight.asFunction();

class BDWPublicAPI extends Struct {
  Pointer<NativeFunction<TGetAppWindow>> getAppWindow;
  Pointer<NativeFunction<TSetWindowCanBeShown>> setWindowCanBeShown;
  Pointer<NativeFunction<TSetInsideDoWhenWindowReady>>
      setInsideDoWhenWindowReady;
  Pointer<NativeFunction<TShowWindow>> showWindow;
  Pointer<NativeFunction<THideWindow>> hideWindow;
  Pointer<NativeFunction<TMoveWindow>> moveWindow;
  Pointer<NativeFunction<TSetSize>> setSize;
  Pointer<NativeFunction<TSetMinSize>> setMinSize;
  Pointer<NativeFunction<TSetMaxSize>> setMaxSize;
  Pointer<NativeFunction<TGetScreenInfoForWindow>> getScreenInfoForWindow;
  Pointer<NativeFunction<TSetPositionForWindow>> setPositionForWindow;
  Pointer<NativeFunction<TSetRectForWindow>> setRectForWindow;
  Pointer<NativeFunction<TGetRectForWindow>> getRectForWindow;
  Pointer<NativeFunction<TIsWindowMaximized>> isWindowVisible;
  Pointer<NativeFunction<TIsWindowMaximized>> isWindowMaximized;
  Pointer<NativeFunction<TMaximizeWindow>> maximizeOrRestoreWindow;
  Pointer<NativeFunction<TMaximizeWindow>> maximizeWindow;
  Pointer<NativeFunction<TMaximizeWindow>> minimizeWindow;
  Pointer<NativeFunction<TCloseWindow>> closeWindow;
  Pointer<NativeFunction<TSetWindowTitle>> setWindowTitle;
  Pointer<NativeFunction<TGetTitleBarHeight>> getTitleBarHeight;
}

class BDWAPI extends Struct {
  Pointer<BDWPublicAPI> publicAPI;
}

typedef Pointer<BDWAPI> TBitsdojoWindowAPI();

final TBitsdojoWindowAPI bitsdojoWindowAPI = _appExecutable
    .lookup<NativeFunction<TBitsdojoWindowAPI>>("bitsdojo_window_api")
    .asFunction();

final Pointer<BDWPublicAPI> _publicAPI = bitsdojoWindowAPI().ref.publicAPI;
