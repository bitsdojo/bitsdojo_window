import './window.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';

class NotImplementedWindow extends DesktopWindow {
  int get handle {
    throw UnimplementedError('handle getter has not been implemented');
  }

  set size(Size newSize) {
    throw UnimplementedError('size setter has not been implemented');
  }

  Size get size {
    throw UnimplementedError('size getter has not been implemented.');
  }

  Rect get rect {
    throw UnimplementedError('rect getter has not been implemented.');
  }

  set rect(Rect newRect) {
    throw UnimplementedError('rect setter has not been implemented.');
  }

  Offset get position {
    throw UnimplementedError('position getter has not been implemented.');
  }

  set position(Offset newPosition) {
    throw UnimplementedError('position setter has not been implemented.');
  }

  set minSize(Size? newSize) {
    throw UnimplementedError('minSize setter has not been implemented.');
  }

  set maxSize(Size? newSize) {
    throw UnimplementedError('maxSize setter has not been implemented.');
  }

  set topmost(bool toomost) {
    throw UnimplementedError('topmost setter has not been implemented.');
  }

  Alignment get alignment {
    throw UnimplementedError('alignment getter has not been implemented.');
  }

  set alignment(Alignment? newAlignment) {
    throw UnimplementedError('alignment setter has not been implemented.');
  }

  set title(String newTitle) {
    throw UnimplementedError('title setter has not been implemented.');
  }

  void show() {
    throw UnimplementedError('show() has not been implemented.');
  }

  void hide() {
    throw UnimplementedError('hide() has not been implemented.');
  }

  @Deprecated("use isVisible instead")
  bool get visible {
    return isVisible;
  }

  bool get isVisible {
    throw UnimplementedError('isVisible has not been implemented.');
  }

  @Deprecated("use show()/hide() instead")
  set visible(bool isVisible) {
    throw UnimplementedError('visible setter has not been implemented.');
  }

  Size get titleBarButtonSize {
    throw UnimplementedError(
        'titleBarButtonSize getter has not been implemented.');
  }

  double get titleBarHeight {
    throw UnimplementedError('titleBarHeight getter has not been implemented.');
  }

  double get borderSize {
    throw UnimplementedError('borderSize getter has not been implemented.');
  }

  void close() {
    throw UnimplementedError('close() has not been implemented.');
  }

  void minimize() {
    throw UnimplementedError('minimize() has not been implemented.');
  }

  void maximize() {
    throw UnimplementedError('maximize() has not been implemented.');
  }

  void maximizeOrRestore() {
    throw UnimplementedError('maximizeOrRestore has not been implemented.');
  }

  void restore() {
    throw UnimplementedError('restore has not been implemented.');
  }

  void startDragging() {
    throw UnimplementedError('startDragging has not been implemented.');
  }

  bool get isMaximized {
    throw UnimplementedError('isMaximized getter has not been implemented.');
  }

  double get scaleFactor {
    throw UnimplementedError('scaleFactor setter has not been implemented');
  }
}
