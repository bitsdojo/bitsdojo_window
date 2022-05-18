import 'package:flutter/painting.dart';

Rect getRectOnScreen(Size sizeOnScreen, Alignment _alignment, Rect screenRect) {
  if (_alignment == Alignment.topLeft) {
    final topLeft = screenRect.topLeft;
    final otherOffset = Offset(
        topLeft.dx + sizeOnScreen.width, topLeft.dy + sizeOnScreen.height);
    return Rect.fromPoints(topLeft, otherOffset);
  }
  if (_alignment == Alignment.topCenter) {
    final topLeft = Offset(screenRect.topCenter.dx - sizeOnScreen.width / 2,
        screenRect.topCenter.dy);
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
    final bottomRight = screenRect.bottomLeft;
    final topLeft = Offset(bottomRight.dx - sizeOnScreen.width,
        bottomRight.dy - sizeOnScreen.height);

    return Rect.fromPoints(topLeft, bottomRight);
  }
  if (_alignment == Alignment.bottomCenter) {
    final topLeft = Offset(screenRect.bottomCenter.dx - sizeOnScreen.width / 2,
        screenRect.bottomCenter.dy - sizeOnScreen.height);
    final bottomRight = Offset(
        topLeft.dx + sizeOnScreen.width, topLeft.dy + sizeOnScreen.height);
    return Rect.fromPoints(topLeft, bottomRight);
  }
  if (_alignment == Alignment.bottomRight) {
    final bottomRight = screenRect.bottomRight;
    final otherOffset = Offset(bottomRight.dx - sizeOnScreen.width,
        bottomRight.dy - sizeOnScreen.height);
    return Rect.fromPoints(bottomRight, otherOffset);
  }
  if (_alignment == Alignment.centerLeft) {
    final centerLeftTop = Offset(screenRect.centerLeft.dx,
        screenRect.centerLeft.dy - sizeOnScreen.height / 2);
    final otherOffset = Offset(centerLeftTop.dx + sizeOnScreen.width,
        centerLeftTop.dy + sizeOnScreen.height);
    return Rect.fromPoints(centerLeftTop, otherOffset);
  }
  if (_alignment == Alignment.center) {
    return Rect.fromCenter(
        center: screenRect.center,
        width: sizeOnScreen.width,
        height: sizeOnScreen.height);
  }
  if (_alignment == Alignment.centerRight) {
    final centerRightTop = Offset(
        screenRect.centerRight.dx - sizeOnScreen.width,
        screenRect.centerRight.dy - sizeOnScreen.height / 2);
    final otherOffset = Offset(centerRightTop.dx + sizeOnScreen.width,
        centerRightTop.dy + sizeOnScreen.height);
    return Rect.fromPoints(centerRightTop, otherOffset);
  }
  // Should not end up here
  assert(false, 'Alignment $_alignment not implemented');
  return Rect.zero;
}
