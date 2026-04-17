import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

const WM_BDW_ACTION = 0x7FFE;

const WPARAM BDW_SETWINDOWPOS = WPARAM(1);
const WPARAM BDW_SETWINDOWTEXT = WPARAM(2);
const WPARAM BDW_FORCECHILDREFRESH = WPARAM(3);

base class SWPParam extends Struct {
  @Int32()
  external int x, y, cx, cy, uFlags;
}

void setWindowPos(HWND hWnd, int hWndInsertAfter, int x, int y, int cx, int cy, int uFlags) {
  final param = calloc<SWPParam>();
  param.ref
    ..x = x
    ..y = y
    ..cx = cx
    ..cy = cy
    ..uFlags = uFlags;
  PostMessage(hWnd, WM_BDW_ACTION, BDW_SETWINDOWPOS, LPARAM(param.address));
}

base class SWTParam extends Struct {
  external Pointer<Utf16> text;
}

void setWindowText(HWND hWnd, String text) {
  final param = calloc<SWTParam>();
  param.ref.text = text.toNativeUtf16();
  PostMessage(hWnd, WM_BDW_ACTION, BDW_SETWINDOWTEXT, LPARAM(param.address));
}

void forceChildRefresh(HWND hWnd) {
  PostMessage(hWnd, WM_BDW_ACTION, BDW_FORCECHILDREFRESH, LPARAM(0));
}
