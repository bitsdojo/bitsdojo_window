// ignore_for_file: non_constant_identifier_names

import 'dart:ui';
import 'package:win32/win32.dart';

extension RECTtoRect on RECT {
  Rect get toRect => Rect.fromLTRB(this.left.toDouble(), this.top.toDouble(),
      this.right.toDouble(), this.bottom.toDouble());
}

extension SIZEtoSize on SIZE {
  Size get toSize => Size(this.cx.toDouble(), this.cy.toDouble());
}
