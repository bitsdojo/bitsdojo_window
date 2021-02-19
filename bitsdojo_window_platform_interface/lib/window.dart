import 'dart:ui';
import 'package:flutter/painting.dart';

abstract class DesktopWindow {
  DesktopWindow();

  Rect get rect;
  set rect(Rect newRect);

  Offset get position;
  set position(Offset newPosition);

  Size get size;
  set size(Size newSize);

  set minSize(Size newSize);
  set maxSize(Size newSize);

  Alignment get alignment;
  set alignment(Alignment newAlignment);

  set title(String newTitle);

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
