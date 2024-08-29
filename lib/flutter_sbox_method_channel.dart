import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'flutter_sbox_platform_interface.dart';

/// An implementation of [FlutterSboxPlatform] that uses method channels.
class MethodChannelFlutterSbox extends FlutterSboxPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('Sbox/FlutterSboxPlugin');

  Future<bool> wrap(bool? ok) async => ok ?? false;

  Future<bool> invokeBool(String method, [dynamic arguments]) async =>
      wrap(await methodChannel.invokeMethod<bool>(method, arguments));

  @override
  Future<bool> startService() async => await invokeBool('startService');

  @override
  Future<bool> stopService() async => await invokeBool('stopService');

  @override
  Future<bool> serviceStarted() async => await invokeBool('serviceStarted');

  @override
  Future<bool> setOptionJson(String optionJson) async =>
      await invokeBool('setOptionJson', optionJson);

  @override
  Future<bool> setConfigJson(String configJson) async =>
      await invokeBool('setConfigJson', configJson);
}
