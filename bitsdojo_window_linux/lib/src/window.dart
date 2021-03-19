import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/painting.dart';

import 'package:ffi/ffi.dart';

import './native_api.dart';
import './gtk.dart';
import 'package:bitsdojo_window_platform_interface/bitsdojo_window_platform_interface.dart';
import './window_util.dart';

bool isValidHandle(int handle, String operation) {
  if (handle == null) {
    print("Could not $operation - handle is null");
    return false;
  }
  return true;
}

Rect getScreenRectForWindow(int handle) {
  final monitor = getWindowMonitor(handle);

  Pointer<Int32> gtkRect = malloc.allocate(sizeOf<Int32>() * 4);
  gdkMonitorGetGeometry(monitor, gtkRect);

  Rect result = Rect.fromLTWH(gtkRect[0].toDouble(), gtkRect[1].toDouble(),
      gtkRect[2].toDouble(), gtkRect[3].toDouble());

  malloc.free(gtkRect);

  return result;
}

class GtkWindow extends DesktopWindow {
  int? handle;
  Size? _minSize;
  Size? _maxSize;
  Alignment? _alignment;

  GtkWindow() {
    _alignment = Alignment.center;
  }

  @override
  bool get visible {
    return isVisible;
  }

  @override
  bool get isVisible {
    //TODO: implement
    return true;
  }

  @override
  Rect get rect {
    Pointer<Int32> gtkRect = malloc.allocate(sizeOf<Int32>() * 4);

    gtkWindowGetPosition(handle!, gtkRect.elementAt(0), gtkRect.elementAt(1));
    gtkWindowGetSize(handle!, gtkRect.elementAt(2), gtkRect.elementAt(3));

    Rect result = Rect.fromLTWH(gtkRect[0].toDouble(), gtkRect[1].toDouble(),
        gtkRect[2].toDouble(), gtkRect[3].toDouble());

    malloc.free(gtkRect);

    return result;
  }

  @override
  set rect(Rect newRect) {
    gtkWindowMove(handle!, newRect.left.toInt(), newRect.top.toInt());
    gtkWindowResize(handle!, newRect.width.toInt(), newRect.height.toInt());
  }

  @override
  Size get size {
    final winRect = this.rect;
    final gotSize = getLogicalSize(Size(winRect.width, winRect.height));
    return gotSize;
  }

  Size get sizeOnScreen {
    final winRect = this.rect;
    return Size(winRect.width, winRect.height);
  }

  @override
  double get borderSize {
    return 0.0;
  }

  int get dpi {
    return (96.0 * this.scaleFactor).toInt();
  }

  double get scaleFactor {
    final monitor = getWindowMonitor(handle!);
    return gdkMonitorGetScaleFactor(monitor).toDouble();
  }

  @override
  double get titleBarHeight {
    // NOTE: This might be difficult to retrieve from gtk
    return 32.0;
  }

  @override
  Size get titleBarButtonSize {
    // NOTE: This might be difficult to retrieve from gtk
    Size result = Size(32, 32);
    return result;
  }

  Size getSizeOnScreen(Size inSize) {
    double scaleFactor = this.scaleFactor;
    double newWidth = inSize.width * scaleFactor;
    double newHeight = inSize.height * scaleFactor;
    return Size(newWidth, newHeight);
  }

  Size getLogicalSize(Size inSize) {
    double scaleFactor = this.scaleFactor;
    double newWidth = inSize.width / scaleFactor;
    double newHeight = inSize.height / scaleFactor;
    return Size(newWidth, newHeight);
  }

  @override
  Alignment get alignment => _alignment!;

  /// How the window should be aligned on screen
  @override
  set alignment(Alignment newAlignment) {
    final sizeOnScreen = this.sizeOnScreen;
    _alignment = newAlignment;
    final screenRect = getScreenRectForWindow(handle!);
    this.rect = getRectOnScreen(sizeOnScreen, _alignment!, screenRect);
  }

  @override
  set minSize(Size newSize) {
    _minSize = newSize;
    setMinSize(_minSize!.width.toInt(), _minSize!.height.toInt());
  }

  @override
  set maxSize(Size newSize) {
    _maxSize = newSize;
    setMaxSize(_maxSize!.width.toInt(), _maxSize!.height.toInt());
  }

  @override
  set size(Size newSize) {
    var width = newSize.width;

    if ((_minSize != null) && (newSize.width < _minSize!.width)) {
      width = _minSize!.width;
    }

    if ((_maxSize != null) && (newSize.width > _maxSize!.width)) {
      width = _maxSize!.width;
    }

    var height = newSize.height;

    if ((_minSize != null) && (newSize.height < _minSize!.height)) {
      height = _minSize!.height;
    }

    if ((_maxSize != null) && (newSize.height > _maxSize!.height)) {
      height = _maxSize!.height;
    }

    Size sizeToSet = Size(width, height);
    if (_alignment == null) {
      gtkWindowResize(
          handle!, sizeToSet.width.toInt(), sizeToSet.height.toInt());
    } else {
      final sizeOnScreen = getSizeOnScreen((sizeToSet));
      final screenRect = getScreenRectForWindow(handle!);
      this.rect = getRectOnScreen(sizeOnScreen, _alignment!, screenRect);
    }
  }

  @override
  bool get isMaximized {
    return gtkWindowIsMaximized(handle!) == 1;
  }

  @override
  Offset get position {
    return this.rect.topLeft;
  }

  @override
  set position(Offset newPosition) {
    gtkWindowMove(handle!, newPosition.dx.toInt(), newPosition.dy.toInt());
  }

  @override
  void show() {
    if (!isValidHandle(handle!, "show")) return;
    gtkWidgetShow(handle!);
  }

  @override
  void hide() {
    if (!isValidHandle(handle!, "hide")) return;
    gtkWidgetHide(handle!);
  }

  @override
  set visible(bool isVisible) {
    if (isVisible) {
      show();
    } else {
      hide();
    }
  }

  @override
  void close() {
    if (!isValidHandle(handle!, "close")) return;
    gtkWindowClose(handle!);
  }

  @override
  void maximize() {
    if (!isValidHandle(handle!, "maximize")) return;
    gtkWindowMaximize(handle!);
  }

  @override
  void minimize() {
    if (!isValidHandle(handle!, "minimize")) return;
    gtkWindowIconify(handle!);
  }

  @override
  void restore() {
    if (!isValidHandle(handle!, "restore")) return;
    gtkWindowUnmaximize(handle!);
  }

  @override
  void maximizeOrRestore() {
    if (!isValidHandle(handle!, "maximizeOrRestore")) return;
    if (this.isMaximized) {
      this.restore();
    } else {
      this.maximize();
    }
  }

  @override
  set title(String newTitle) {
    if (!isValidHandle(handle!, "set title")) return;
    final nativeString = newTitle.toNativeUtf8();
    gtkWindowSetTitle(handle!, nativeString);
    malloc.free(nativeString);
  }

  @override
  void startDragging() {
    BitsdojoWindowPlatform.instance.dragAppWindow();
  }
}
