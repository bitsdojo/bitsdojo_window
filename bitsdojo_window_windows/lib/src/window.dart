import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/painting.dart';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import './win32_plus.dart';
import './native_api.dart';
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
  int monitor = MonitorFromWindow(handle, MONITOR_DEFAULTTONEAREST);
  final monitorInfo = calloc<MONITORINFO>()..ref.cbSize = sizeOf<MONITORINFO>();
  final result = GetMonitorInfo(monitor, monitorInfo);
  if (result == TRUE) {
    return Rect.fromLTRB(
        monitorInfo.ref.rcWork.left.toDouble(),
        monitorInfo.ref.rcWork.top.toDouble(),
        monitorInfo.ref.rcWork.right.toDouble(),
        monitorInfo.ref.rcWork.bottom.toDouble());
  }
  return Rect.zero;
}

class WinWindow extends DesktopWindow {
  int handle;
  Size _minSize;
  Size _maxSize;
  Alignment _alignment;

  WinWindow() {
    _alignment = Alignment.center;
  }

  Rect get rect {
    final winRect = calloc<RECT>();
    GetWindowRect(handle, winRect);
    Rect result = winRect.ref.toRect;
    calloc.free(winRect);
    return result;
  }

  set rect(Rect newRect) {
    setWindowPos(handle, 0, newRect.left.toInt(), newRect.top.toInt(),
        newRect.width.toInt(), newRect.height.toInt(), 0);
  }

  Size get size {
    final winRect = this.rect;
    final gotSize = getLogicalSize(Size(winRect.width, winRect.height));
    return gotSize;
  }

  Size get sizeOnScreen {
    final winRect = this.rect;
    return Size(winRect.width, winRect.height);
  }

  double systemMetric(int metric, {int dpiToUse = 0}) {
    final windowDpi = dpiToUse != 0 ? dpiToUse : this.dpi;
    double result = GetSystemMetricsForDpi(metric, windowDpi).toDouble();
    return result;
  }

  double get borderSize {
    return this.systemMetric(SM_CXBORDER);
  }

  int get dpi {
    return GetDpiForWindow(handle);
  }

  double get scaleFactor {
    double result = this.dpi / 96.0;
    return result;
  }

  double get titleBarHeight {
    double scaleFactor = this.scaleFactor;
    int dpiToUse = this.dpi;
    double cyCaption = systemMetric(SM_CYCAPTION, dpiToUse: dpiToUse);
    cyCaption = (cyCaption / scaleFactor);
    double cySizeFrame = systemMetric(SM_CYSIZEFRAME, dpiToUse: dpiToUse);
    cySizeFrame = (cySizeFrame / scaleFactor);
    double cxPaddedBorder = systemMetric(SM_CXPADDEDBORDER, dpiToUse: dpiToUse);
    cxPaddedBorder = (cxPaddedBorder / scaleFactor).ceilToDouble();
    double result = cySizeFrame + cyCaption + cxPaddedBorder;
    return result;
  }

  Size get titleBarButtonSize {
    double height = this.titleBarHeight - this.borderSize;
    double scaleFactor = this.scaleFactor;
    double cyCaption = systemMetric(SM_CYCAPTION);
    cyCaption /= scaleFactor;
    double width = cyCaption * 2;
    return Size(width, height);
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

  Alignment get alignment => _alignment;

  /// How the window should be aligned on screen
  set alignment(Alignment newAlignment) {
    final sizeOnScreen = this.sizeOnScreen;
    _alignment = newAlignment;
    final screenRect = getScreenRectForWindow(handle);
    final rectOnScreen = getRectOnScreen(sizeOnScreen, _alignment, screenRect);
    this.rect = rectOnScreen;
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
      final sizeOnScreen = getSizeOnScreen((sizeToSet));
      final screenRect = getScreenRectForWindow(handle);
      this.rect = getRectOnScreen(sizeOnScreen, _alignment, screenRect);
    }
  }

  bool get isMaximized {
    return (IsZoomed(handle) == 1);
  }

  @Deprecated("use isVisible instead")
  bool get visible {
    return isVisible;
  }

  bool get isVisible {
    return (IsWindowVisible(handle) == 1);
  }

  Offset get position {
    final winRect = this.rect;
    return Offset(winRect.left, winRect.top);
  }

  set position(Offset newPosition) {
    SetWindowPos(handle, 0, newPosition.dx.toInt(), newPosition.dy.toInt(), 0,
        0, SWP_NOSIZE);
  }

  void show() {
    if (!isValidHandle(handle, "show")) return;
    setWindowPos(
        handle, 0, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE | SWP_SHOWWINDOW);
    forceChildRefresh(handle);
  }

  void hide() {
    if (!isValidHandle(handle, "hide")) return;
    SetWindowPos(
        handle, 0, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE | SWP_HIDEWINDOW);
  }

  @Deprecated("use show()/hide() instead")
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
    setWindowText(handle, newTitle);
  }

  void startDragging() {
    BitsdojoWindowPlatform.instance.dragAppWindow();
  }
}
