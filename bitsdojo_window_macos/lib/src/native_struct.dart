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
