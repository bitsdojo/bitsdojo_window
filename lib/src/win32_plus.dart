// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';
import 'dart:ui';
import 'package:win32/win32.dart';

final _user32 = DynamicLibrary.open('user32.dll');

const SWP_NOSIZE = 0x0001;
const SWP_NOMOVE = 0x0002;
const SWP_SHOWWINDOW = 0x0040;
const SWP_HIDEWINDOW = 0x0080;
const SWP_NOREDRAW = 0x0008;

const SC_CLOSE = 0xF060;
const SC_MAXIMIZE = 0xF030;
const SC_MINIMIZE = 0xF020;
const SC_RESTORE = 0XF120;

final PostMessage = _user32.lookupFunction<
    IntPtr Function(IntPtr hWnd, Uint32 msg, IntPtr wParam, IntPtr lParam),
    int Function(int hWnd, int msg, int wParam, int lParam)>('PostMessageW');

final GetWindowRect = _user32.lookupFunction<
    Int32 Function(IntPtr hwnd, Pointer<RECT> lpRect),
    int Function(int hwnd, Pointer<RECT> lpRect)>('GetWindowRect');

final GetDpiForWindow = _user32.lookupFunction<Uint32 Function(IntPtr hwnd),
    int Function(int hwnd)>("GetDpiForWindow");

final GetSystemMetricsForDpi = _user32.lookupFunction<
    Int32 Function(Int32 nIndex, Uint32 dpi),
    int Function(int nIndex, int dpi)>('GetSystemMetricsForDpi');

final IsZoomed =
    _user32.lookupFunction<Int32 Function(IntPtr hWnd), int Function(int hWnd)>(
        'IsZoomed');

extension RECTtoRect on RECT {
  Rect get toRect => Rect.fromLTRB(this.left.toDouble(), this.top.toDouble(),
      this.right.toDouble(), this.bottom.toDouble());
}

extension SIZEtoSize on SIZE {
  Size get toSize => Size(this.cx.toDouble(), this.cy.toDouble());
}

const SM_CYCAPTION = 4;
const SM_CXBORDER = 5;
const SM_CXSIZE = 30;
const SM_CYSIZE = 31;
const SM_CYSIZEFRAME = 33;
const SM_CXPADDEDBORDER = 92;
