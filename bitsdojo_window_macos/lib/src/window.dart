import 'package:bitsdojo_window_platform_interface/bitsdojo_window_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import './window_util.dart';
import './native_api.dart';

class MacOSWindow extends DesktopWindow {
  int handle;
  Size _minSize;
  Size _maxSize;
  Alignment _alignment;

  MacOSWindow() {
    _alignment = Alignment.center;
  }

  Size get size {
    final winRect = this.rect;
    return Size(winRect.right - winRect.left, winRect.bottom - winRect.top);
  }

  Rect get rect => getRectForWindow(handle);

  set rect(Rect newRect) {
    setRectForWindow(handle, newRect);
  }

  Offset get position {
    final winRect = this.rect;
    return Offset(winRect.left, winRect.top);
  }

  set position(Offset newPosition) {
    //TODO: implement
  }

  Alignment get alignment => _alignment;
  set alignment(Alignment newAlignment) {
    _alignment = newAlignment;
    final screenRect = getScreenRectForWindow(handle);
    final windowRect = getRectOnScreen(this.size, _alignment, screenRect);
    final newTop = screenRect.height - windowRect.top - windowRect.height;
    final newBottom = newTop + windowRect.height;
    this.rect =
        Rect.fromLTRB(windowRect.left, newTop, windowRect.right, newBottom);
  }

  set minSize(Size newSize) {
    _minSize = newSize;
    setMinSize(handle, _minSize.width.toInt(), _minSize.height.toInt());
  }

  set maxSize(Size newSize) {
    //TODO: Implement
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
      setSize(handle, sizeToSet.width.toInt(), sizeToSet.height.toInt());
    } else {
      final screenRect = getScreenRectForWindow(handle);
      this.rect = getRectOnScreen(sizeToSet, _alignment, screenRect);
    }
  }

  double get titleBarHeight {
    //TODO: implement
    return 30.0;
  }

  Size get titleBarButtonSize {
    //TODO: implement
    return Size(0, 0);
  }

  set title(String newTitle) {
    //TODO: implement
  }

  double get borderSize {
    //borderSize is zero on macOS
    return 0;
  }

  set visible(bool isVisible) {
    //TODO: implement
  }

  void show() {
    showWindow(handle);
  }

  void hide() {
    //TODO: implement
  }

  void close() {
    //TODO: implement
  }

  void minimize() {
    //TODO: implement
  }

  void maximize() {
    //TODO: implement
  }

  void restore() {
    //TODO: implement
  }

  bool get isMaximized {
    //TODO: implement
    return false;
  }

  void startDragging() {
    moveWindow(handle);
  }

  void maximizeOrRestore() {
    maximizeWindow(handle);
  }
}
