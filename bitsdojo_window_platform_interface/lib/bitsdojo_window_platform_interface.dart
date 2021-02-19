import 'dart:ui';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_bitsdojo_window.dart';
import './window.dart';

export './window.dart';
export './window_common.dart';

/// The interface that implementations of bitsdojo_window must implement.
///
/// Platform implementations should extend this class rather than implement it as `bitsdojo_window`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [BitsdojoWindowPlatform] methods.
abstract class BitsdojoWindowPlatform extends PlatformInterface {
  /// Constructs a BitsdojoWindowPlatform.
  BitsdojoWindowPlatform() : super(token: _token);

  static final Object _token = Object();

  static BitsdojoWindowPlatform _channelInstance =
      MethodChannelBitsdojoWindow();
  static BitsdojoWindowPlatform _instance = _channelInstance;

  /// The default instance of [BitsdojoWindowPlatform] to use.
  ///
  /// Defaults to [MethodChannelBitsdojoWindow].
  static BitsdojoWindowPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [BitsdojoWindowPlatform] when they register themselves.
  static set instance(BitsdojoWindowPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  void doWhenWindowReady(VoidCallback callback) {
    throw UnimplementedError('doWhenWindowReady() has not been implemented.');
  }

  DesktopWindow get appWindow {
    throw UnimplementedError('appWindow has not been implemented.');
  }

  void dragAppWindow() async {
    _channelInstance.dragAppWindow();
  }
}
