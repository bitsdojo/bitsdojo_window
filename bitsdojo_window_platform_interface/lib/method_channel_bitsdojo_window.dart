import 'package:flutter/services.dart';

import 'bitsdojo_window_platform_interface.dart';

const MethodChannel _channel = MethodChannel('bitsdojo/window');

/// An implementation of [BitsdojoWindowPlatform] that uses method channels.
class MethodChannelBitsdojoWindow extends BitsdojoWindowPlatform {
  @override
  void dragAppWindow() async {
    try {
      await _channel.invokeMethod('dragAppWindow');
    } catch (e) {
      print("Could not start draggging -> $e");
    }
  }
}
