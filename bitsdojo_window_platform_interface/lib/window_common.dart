import 'dart:ui';
import 'package:flutter/painting.dart';

Rect getRectOnScreen(Size sizeOnScreen, Alignment _alignment, Rect screenRect) {
  if (_alignment == Alignment.center) {
    return Rect.fromCenter(
        center: screenRect.center,
        width: sizeOnScreen.width,
        height: sizeOnScreen.height);
  }
  if (_alignment == Alignment.topLeft) {
    final topLeft = screenRect.topLeft;
    final otherOffset = Offset(
        topLeft.dx + sizeOnScreen.width, topLeft.dy + sizeOnScreen.height);
    return Rect.fromPoints(topLeft, otherOffset);
  }
  if (_alignment == Alignment.topRight) {
    final topRight = screenRect.topRight;
    final otherOffset = Offset(
        topRight.dx - sizeOnScreen.width, topRight.dy + sizeOnScreen.height);
    return Rect.fromPoints(otherOffset, topRight);
  }
  if (_alignment == Alignment.bottomLeft) {
    final bottomLeft = screenRect.bottomLeft;
    final otherOffset = Offset(bottomLeft.dx + sizeOnScreen.width,
        bottomLeft.dy - sizeOnScreen.height);
    return Rect.fromPoints(bottomLeft, otherOffset);
  }
  if (_alignment == Alignment.bottomRight) {
    final bottomRight = screenRect.bottomRight;
    final otherOffset = Offset(bottomRight.dx - sizeOnScreen.width,
        bottomRight.dy - sizeOnScreen.height);
    return Rect.fromPoints(bottomRight, otherOffset);
  }
  // Should not end up here
  assert(false, 'Alignment $_alignment not implemented');
  return Rect.zero;
}
