library bitsdojo_window_windows_v3;

import 'dart:ffi';

final DynamicLibrary _appExecutable = DynamicLibrary.executable();

// isBitsdojoWindowLoaded
typedef Int8 TIsBitsdojoWindowLoaded();
typedef DTIsBitsdojoWindowLoaded = int Function();
final DTIsBitsdojoWindowLoaded? _isBitsdojoWindowLoaded =
    _publicAPI.ref.isBitsdojoWindowLoaded.asFunction();

bool isBitsdojoWindowLoaded() {
  if (_isBitsdojoWindowLoaded == null) {
    return false;
  }
  return _isBitsdojoWindowLoaded!() == 1 ? true : false;
}

// getAppWindow
typedef IntPtr TGetAppWindow();
typedef DGetAppWindow = int Function();
final DGetAppWindow getAppWindow = _publicAPI.ref.getAppWindow.asFunction();

// isDPIAware
typedef Int8 TIsDPIAware();
typedef DIsDPIAware = int Function();
final DIsDPIAware _isDPIAware = _publicAPI.ref.isDPIAware.asFunction();
bool isDPIAware() => _isDPIAware() != 0;

// setWindowCanBeShown
typedef Void TSetWindowCanBeShown(Int8 value);
typedef DSetWindowCanBeShown = void Function(int value);
final DSetWindowCanBeShown _setWindowCanBeShown =
    _publicAPI.ref.setWindowCanBeShown.asFunction();
void setWindowCanBeShown(bool value) => _setWindowCanBeShown(value ? 1 : 0);

// setMinSize
typedef Void TSetMinSize(Int32 width, Int32 height);
typedef DSetMinSize = void Function(int width, int height);
final DSetMinSize setMinSize = _publicAPI.ref.setMinSize.asFunction();

// setMaxSize
typedef Void TSetMaxSize(Int32 width, Int32 height);
typedef DSetMaxSize = void Function(int width, int height);
final DSetMinSize setMaxSize = _publicAPI.ref.setMaxSize.asFunction();

// setWindowCutOnMaximize
typedef Void TSetWindowCutOnMaximize(Int32 width);
typedef DSetWindowCutOnMaximize = void Function(int width);
final DSetWindowCutOnMaximize setWindowCutOnMaximize =
    _publicAPI.ref.setWindowCutOnMaximize.asFunction();

sealed class BDWPublicAPI extends Struct {
  external Pointer<NativeFunction<TIsBitsdojoWindowLoaded>>
      isBitsdojoWindowLoaded;
  external Pointer<NativeFunction<TGetAppWindow>> getAppWindow;
  external Pointer<NativeFunction<TSetWindowCanBeShown>> setWindowCanBeShown;
  external Pointer<NativeFunction<TSetMinSize>> setMinSize;
  external Pointer<NativeFunction<TSetMaxSize>> setMaxSize;
  external Pointer<NativeFunction<TSetWindowCutOnMaximize>>
      setWindowCutOnMaximize;
  external Pointer<NativeFunction<TIsDPIAware>> isDPIAware;
}

sealed class BDWAPI extends Struct {
  external Pointer<BDWPublicAPI> publicAPI;
}

typedef Pointer<BDWAPI> TBitsdojoWindowAPI();

final TBitsdojoWindowAPI bitsdojoWindowAPI = _appExecutable
    .lookup<NativeFunction<TBitsdojoWindowAPI>>("bitsdojo_window_api")
    .asFunction();

final Pointer<BDWPublicAPI> _publicAPI = bitsdojoWindowAPI().ref.publicAPI;
