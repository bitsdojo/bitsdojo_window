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
  bool _setTitleOnNextShow;
  String _titleToSet;

  MacOSWindow() {
    _alignment = Alignment.center;
    _setTitleOnNextShow = false;
  }

  Size get size {
    final winRect = this.rect;
    return Size(winRect.right - winRect.left, winRect.bottom - winRect.top);
  }

  Rect get rect => getRectForWindow(handle);

  set rect(Rect newRect) {
    var widthToSet =
        newRect.width < _minSize.width ? _minSize.width : newRect.width;
    var heightToSet =
        newRect.height < _minSize.height ? _minSize.height : newRect.height;
    final rectToSet =
        Rect.fromLTWH(newRect.left, newRect.top, widthToSet, heightToSet);
    setRectForWindow(handle, rectToSet);
  }

  Offset get position {
    final winRect = this.rect;
    return Offset(winRect.left, winRect.top);
  }

  set position(Offset newPosition) {
    setPositionForWindow(handle, newPosition);
  }

  Alignment get alignment => _alignment;
  set alignment(Alignment newAlignment) {
    _alignment = newAlignment;
    final screenInfo = getScreenInfoForWindow(handle);
    final windowRect =
        getRectOnScreen(this.size, _alignment, screenInfo.workingRect);
    final menuBarHeight = screenInfo.workingRect.top;
    // We need to subtract menuBarHeight because .position uses
    // setFrameTopLeftPoint internally and that needs an offset
    // relative to the start of the working rectangle (after the menu bar)
    final positionToSet = windowRect.topLeft.translate(0, -menuBarHeight);
    this.position = positionToSet;
  }

  set minSize(Size newSize) {
    _minSize = newSize;
    setMinSize(handle, _minSize.width.toInt(), _minSize.height.toInt());
  }

  set maxSize(Size newSize) {
    _maxSize = newSize;
    setMaxSize(handle, _maxSize.width.toInt(), _maxSize.height.toInt());
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
      final screenInfo = getScreenInfoForWindow(handle);
      this.rect =
          getRectOnScreen(sizeToSet, _alignment, screenInfo.workingRect);
    }
  }

  Size get titleBarButtonSize {
    throw UnimplementedError(
        'titleBarButtonSize getter has not been implemented.');
  }

  double get titleBarHeight {
    return getTitleBarHeight(handle);
  }

  set title(String newTitle) {
    // Save title internally because window might be hidden
    // so title won't be set. Will set it on next show()
    if (this.isVisible == false) {
      _setTitleOnNextShow = true;
      _titleToSet = newTitle;
    }
    setWindowTitle(handle, newTitle);
  }

  double get borderSize {
    //borderSize is zero on macOS
    return 0;
  }

  @Deprecated("use isVisible instead")
  bool get visible {
    return isVisible;
  }

  bool get isVisible {
    return isWindowVisible(handle);
  }

  @Deprecated("use show()/hide() instead")
  set visible(bool isVisible) {
    if (isVisible) {
      show();
    } else {
      hide();
    }
  }

  void show() {
    showWindow(handle);
    if (_setTitleOnNextShow) {
      _setTitleOnNextShow = false;
      setWindowTitle(handle, _titleToSet);
    }
  }

  void hide() {
    hideWindow(handle);
  }

  void close() {
    closeWindow(handle);
  }

  void minimize() {
    minimizeWindow(handle);
  }

  void maximize() {
    maximizeWindow(handle);
  }

  void restore() {
    if (this.isMaximized) {
      maximizeOrRestore();
    }
  }

  bool get isMaximized {
    return isWindowMaximized(handle);
  }

  void startDragging() {
    moveWindow(handle);
  }

  void maximizeOrRestore() {
    maximizeOrRestoreWindow(handle);
  }
}
