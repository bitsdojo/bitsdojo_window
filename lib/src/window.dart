import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/painting.dart';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import './win32_plus.dart';
import './native_api.dart';

bool isValidHandle(int handle, String operation) {
  if (handle == null) {
    print("Could not $operation - handle is null");
    return false;
  }
  return true;
}

Rect getMonitorRectForWindow(int handle) {
  int monitor = MonitorFromWindow(handle, MONITOR_DEFAULTTONEAREST);
  final monitorInfo = MONITORINFO.allocate();
  final result = GetMonitorInfo(monitor, monitorInfo.addressOf);
  if (result == TRUE) {
    return Rect.fromLTRB(
        monitorInfo.rcWorkLeft.toDouble(),
        monitorInfo.rcWorkTop.toDouble(),
        monitorInfo.rcWorkRight.toDouble(),
        monitorInfo.rcWorkBottom.toDouble());
  }
  return Rect.zero;
}

class Window {
  int handle;
  Size _minSize;
  Size _maxSize;
  Alignment _alignment;

  Window() {
    _alignment = Alignment.center;
  }

  Rect get rect {
    final winRect = RECT.allocate();
    GetWindowRect(handle, winRect.addressOf);
    Rect result = winRect.toRect;
    free(winRect.addressOf);
    return result;
  }

  set rect(Rect newRect) {
    SetWindowPos(handle, 0, newRect.left.toInt(), newRect.top.toInt(),
        newRect.width.toInt(), newRect.height.toInt(), 0);
  }

  Size get size {
    var winRect = this.rect;
    var gotSize = getLogicalSize(Size(winRect.width, winRect.height));
    return gotSize;
  }

  Size get sizeOnScreen {
    var winRect = this.rect;
    return Size(winRect.width, winRect.height);
  }

  Size getSizeOnScreen(Size inSize) {
    int dpi = GetDpiForWindow(handle);
    double scaleFactor = dpi / 96.0;
    double newWidth = inSize.width * scaleFactor;
    double newHeight = inSize.height * scaleFactor;
    return Size(newWidth, newHeight);
  }

  Size getLogicalSize(Size inSize) {
    int dpi = GetDpiForWindow(handle);
    double scaleFactor = dpi / 96.0;
    double newWidth = inSize.width / scaleFactor;
    double newHeight = inSize.height / scaleFactor;
    return Size(newWidth, newHeight);
  }

  void _updatePositionForSize(Size sizeOnScreen) {
    var monitorRect = getMonitorRectForWindow(handle);
    if (_alignment == Alignment.center) {
      this.rect = Rect.fromCenter(
          center: monitorRect.center,
          width: sizeOnScreen.width,
          height: sizeOnScreen.height);
    }
    if (_alignment == Alignment.topLeft) {
      var topLeft = monitorRect.topLeft;
      var otherOffset = Offset(
          topLeft.dx + sizeOnScreen.width, topLeft.dy + sizeOnScreen.height);
      this.rect = Rect.fromPoints(topLeft, otherOffset);
      return;
    }
    if (_alignment == Alignment.topRight) {
      var topRight = monitorRect.topRight;
      var otherOffset = Offset(
          topRight.dx - sizeOnScreen.width, topRight.dy + sizeOnScreen.height);
      this.rect = Rect.fromPoints(otherOffset, topRight);
      return;
    }
    if (_alignment == Alignment.bottomLeft) {
      var bottomLeft = monitorRect.bottomLeft;
      var otherOffset = Offset(bottomLeft.dx + sizeOnScreen.width,
          bottomLeft.dy - sizeOnScreen.height);
      this.rect = Rect.fromPoints(bottomLeft, otherOffset);
    }
    if (_alignment == Alignment.bottomRight) {
      var bottomRight = monitorRect.bottomRight;
      var otherOffset = Offset(bottomRight.dx - sizeOnScreen.width,
          bottomRight.dy - sizeOnScreen.height);
      this.rect = Rect.fromPoints(bottomRight, otherOffset);
    }
  }

  get alignment => _alignment;

  /// How the window should be aligned on screen
  set alignment(Alignment newAlignment) {
    var sizeOnScreen = this.sizeOnScreen;
    _alignment = newAlignment;
    _updatePositionForSize(sizeOnScreen);
  }

  set minSize(Size newSize) {
    _minSize = newSize;
    setMinSize(_minSize.width.toInt(), _minSize.height.toInt());
  }

  set maxSize(Size newSize) {
    _maxSize = newSize;
    setMaxSize(_maxSize.width.toInt(), _maxSize.height.toInt());
  }

  set size(Size newSize) {
    var width = newSize.width;

    if ((_minSize != null) && (newSize.width < _minSize.width)) {
      width = _minSize.width;
    }

    if ((_maxSize != null) && (newSize.width > _maxSize.width)) {
      width = _maxSize.width;
    }

    var height = newSize.height;

    if ((_minSize != null) && (newSize.height < _minSize.height)) {
      height = _minSize.height;
    }

    if ((_maxSize != null) && (newSize.height > _maxSize.height)) {
      height = _maxSize.height;
    }

    Size sizeToSet = Size(width, height);
    if (_alignment == null) {
      SetWindowPos(handle, 0, 0, 0, sizeToSet.width.toInt(),
          sizeToSet.height.toInt(), SWP_NOMOVE);
    } else {
      var sizeOnScreen = getSizeOnScreen((sizeToSet));
      _updatePositionForSize(sizeOnScreen);
    }
  }

  bool get isMaximized {
    return (IsZoomed(handle) == 1);
  }

  Offset get position {
    var winRect = this.rect;
    return Offset(winRect.left, winRect.top);
  }

  set position(Offset newPosition) {
    SetWindowPos(handle, 0, newPosition.dx.toInt(), newPosition.dy.toInt(), 0,
        0, SWP_NOSIZE);
  }

  void show() {
    if (!isValidHandle(handle, "show")) return;
    SetWindowPos(
        handle, 0, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE | SWP_SHOWWINDOW);
  }

  void hide() {
    if (!isValidHandle(handle, "hide")) return;
    SetWindowPos(
        handle, 0, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE | SWP_HIDEWINDOW);
  }

  set visible(bool isVisible) {
    if (isVisible) {
      show();
    } else {
      hide();
    }
  }

  void close() {
    if (!isValidHandle(handle, "close")) return;
    PostMessage(handle, WM_SYSCOMMAND, SC_CLOSE, 0);
  }

  void maximize() {
    if (!isValidHandle(handle, "maximize")) return;
    PostMessage(handle, WM_SYSCOMMAND, SC_MAXIMIZE, 0);
  }

  void minimize() {
    if (!isValidHandle(handle, "minimize")) return;

    PostMessage(handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
  }

  void restore() {
    if (!isValidHandle(handle, "restore")) return;
    PostMessage(handle, WM_SYSCOMMAND, SC_RESTORE, 0);
  }

  void maximizeOrRestore() {
    if (!isValidHandle(handle, "maximizeOrRestore")) return;
    if (IsZoomed(handle) == 1) {
      this.restore();
    } else {
      this.maximize();
    }
  }

  set title(String newTitle) {
    if (!isValidHandle(handle, "set title")) return;
    SetWindowText(handle, TEXT(newTitle));
  }
}
