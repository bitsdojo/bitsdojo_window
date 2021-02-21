import 'dart:ffi';
import './win32_plus.dart';
import 'package:ffi/ffi.dart';

const WM_BDW_ACTION = 0x7FFE;

const BDW_SETWINDOWPOS = 1;
const BDW_SETWINDOWTEXT = 2;
const BDW_FORCECHILDREFRESH = 3;

class SWPParam extends Struct {
  @Int32()
  int x, y, cx, cy, uFlags;
}

void setWindowPos(
    int hWnd, int hWndInsertAfter, int x, int y, int cx, int cy, int uFlags) {
  final param = allocate<SWPParam>();
  param.ref
    ..x = x
    ..y = y
    ..cx = cx
    ..cy = cy
    ..uFlags = uFlags;
  PostMessage(hWnd, WM_BDW_ACTION, BDW_SETWINDOWPOS, param.address);
}

class SWTParam extends Struct {
  Pointer<Utf16> text;
}

void setWindowText(int hWnd, String text) {
  final param = allocate<SWTParam>();
  param.ref.text = Utf16.toUtf16(text);
  PostMessage(hWnd, WM_BDW_ACTION, BDW_SETWINDOWTEXT, param.address);
}

void forceChildRefresh(int hWnd) {
  PostMessage(hWnd, WM_BDW_ACTION, BDW_FORCECHILDREFRESH, 0);
}
