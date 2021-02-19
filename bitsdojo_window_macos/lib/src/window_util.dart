import 'dart:ffi';
import './native_struct.dart';
import 'package:flutter/painting.dart';
import './native_api.dart';

Rect getScreenRectForWindow(int window) {
  Rect result;
  final Pointer<BDWRect> rectPointer = newBDWRect();
  final bdwResult = getScreenRectNative(window, rectPointer);
  if (bdwResult == true) {
    result = Rect.fromLTRB(rectPointer.ref.left, rectPointer.ref.top,
        rectPointer.ref.right, rectPointer.ref.bottom);
  } else {
    assert(false);
    result = Rect.zero;
  }
  //free(rectPointer);
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
