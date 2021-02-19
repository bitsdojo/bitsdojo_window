import 'dart:async';
import 'package:flutter/services.dart';

class BitsdojoWindowMacos {
  static const MethodChannel _channel =
      const MethodChannel('bitsdojo_window_macos');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
