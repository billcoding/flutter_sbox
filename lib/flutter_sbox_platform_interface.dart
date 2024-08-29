import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_sbox_method_channel.dart';

abstract class FlutterSboxPlatform extends PlatformInterface {
  /// Constructs a FlutterSboxPlatform.
  FlutterSboxPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterSboxPlatform _instance = MethodChannelFlutterSbox();

  /// The default instance of [FlutterSboxPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterSbox].
  static FlutterSboxPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterSboxPlatform] when
  /// they register themselves.
  static set instance(FlutterSboxPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> startService() {
    throw UnimplementedError('startService() has not been implemented.');
  }

  Future<bool> stopService() {
    throw UnimplementedError('stopService() has not been implemented.');
  }

  Future<bool> serviceStarted() {
    throw UnimplementedError('serviceStarted() has not been implemented.');
  }

  Future<bool> setOptionJson(String optionJson) {
    throw UnimplementedError('setOptionJson() has not been implemented.');
  }

  Future<bool> setConfigJson(String configJson) {
    throw UnimplementedError('setConfigJson() has not been implemented.');
  }
}
