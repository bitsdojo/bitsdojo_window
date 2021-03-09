import 'dart:ffi';
import 'package:ffi/ffi.dart';

class BDWRect extends Struct {
  @Double()
  double left, top, right, bottom;
}

Pointer<BDWRect> newBDWRect() {
  final result = calloc<BDWRect>();
  result.ref
    ..left = 0
    ..top = 0
    ..right = 0
    ..bottom = 0;
  return result;
}

class BDWScreenInfo extends Struct {
  Pointer<BDWRect> workingRect;
  Pointer<BDWRect> fullRect;
}

Pointer<BDWScreenInfo> newBDWScreenInfo() {
  final result = calloc<BDWScreenInfo>();
  result.ref
    ..workingRect = newBDWRect()
    ..fullRect = newBDWRect();
  return result;
}

extension FreeBDWScreenInfo on Pointer<BDWScreenInfo> {
  void free() {
    calloc.free(this.ref.workingRect);
    calloc.free(this.ref.fullRect);
    calloc.free(this);
  }
}

class BDWOffset extends Struct {
  @Double()
  double x, y;
}

Pointer<BDWOffset> newBDWOffset() {
  final result = calloc<BDWOffset>();
  result.ref
    ..x = 0
    ..y = 0;
  return result;
}
