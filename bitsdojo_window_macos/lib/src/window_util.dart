import 'dart:ffi';
import './native_struct.dart';
import 'package:flutter/painting.dart';
import './native_api.dart';

class ScreenInfo {
  Rect? workingRect;
  Rect? fullRect;
}

ScreenInfo getScreenInfoForWindow(int window) {
  var result = ScreenInfo();
  final Pointer<BDWScreenInfo> screenInfoPointer = newBDWScreenInfo();
  final bdwResult = getScreenInfoNative(window, screenInfoPointer);
  final Pointer<BDWRect> workingRectPointer = screenInfoPointer.ref.workingRect;
  final Pointer<BDWRect> fullRectPointer = screenInfoPointer.ref.fullRect;
  BDWRect workingRect = workingRectPointer.ref;
  BDWRect fullRect = fullRectPointer.ref;

  if (bdwResult == true) {
    result.workingRect = Rect.fromLTRB(workingRect.left, workingRect.top,
        workingRect.right, workingRect.bottom);
    result.fullRect = Rect.fromLTRB(
        fullRect.left, fullRect.top, fullRect.right, fullRect.bottom);
  } else {
    assert(false);
    result.workingRect = Rect.zero;
    result.fullRect = Rect.zero;
  }
  screenInfoPointer.free();
  return result;
}

Rect getRectForWindow(int window) {
  Rect result;
  final Pointer<BDWRect> rectPointer = newBDWRect();
  final bdwResult = getRectForWindowNative(window, rectPointer);
  if (bdwResult == BDW_SUCCESS) {
    result = Rect.fromLTRB(rectPointer.ref.left, rectPointer.ref.top,
        rectPointer.ref.right, rectPointer.ref.bottom);
  } else {
    assert(false);
    result = Rect.zero;
  }
  //free(rectPointer);
  return result;
}

void setRectForWindow(int window, Rect newRect) {
  final Pointer<BDWRect> rectPointer = newBDWRect();
  rectPointer.ref
    ..left = newRect.left
    ..top = newRect.top
    ..right = newRect.right
    ..bottom = newRect.bottom;
  setRectForWindowNative(window, rectPointer);
  //free(rectPointer);
}
