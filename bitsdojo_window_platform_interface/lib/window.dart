import 'package:flutter/painting.dart';

abstract class DesktopWindow {
  DesktopWindow();
  int? get handle;
  double get scaleFactor;

  Rect get rect;
  set rect(Rect newRect);

  Offset get position;
  set position(Offset newPosition);

  Size get size;
  set size(Size newSize);

  set minSize(Size? newSize);
  set maxSize(Size? newSize);

  Alignment? get alignment;
  set alignment(Alignment? newAlignment);

  set title(String newTitle);

  @Deprecated("use isVisible instead")
  bool get visible;
  bool get isVisible;
  @Deprecated("use show()/hide() instead")
  set visible(bool isVisible);
  void show();
  void hide();
  void close();
  void minimize();
  void maximize();
  void maximizeOrRestore();
  void restore();

  void startDragging();

  Size get titleBarButtonSize;
  double get titleBarHeight;
  double get borderSize;
  bool get isMaximized;
}
