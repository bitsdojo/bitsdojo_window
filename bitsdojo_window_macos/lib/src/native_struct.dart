import 'dart:ffi';
import 'package:ffi/ffi.dart';

sealed class BDWRect extends Struct {
  @Double()
  external double left, top, right, bottom;
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

sealed class BDWScreenInfo extends Struct {
  external Pointer<BDWRect> workingRect;
  external Pointer<BDWRect> fullRect;
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

sealed class BDWOffset extends Struct {
  @Double()
  external double x, y;
}

Pointer<BDWOffset> newBDWOffset() {
  final result = calloc<BDWOffset>();
  result.ref
    ..x = 0
    ..y = 0;
  return result;
}
