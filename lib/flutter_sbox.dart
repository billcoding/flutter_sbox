import 'package:flutter/services.dart';

final class FlutterSbox {
  static const methodChannel = MethodChannel('Sbox/FlutterSboxPlugin');

  static Future<bool> wrapBool(bool? ok) async => ok ?? false;

  static Future<int> wrapInt(int? value) async => value ?? 0;

  static Future<bool> invokeBool(String method, [dynamic arguments]) async =>
      wrapBool(await methodChannel.invokeMethod<bool>(method, arguments));

  static Future<int> invokeInt(String method, [dynamic arguments]) async =>
      wrapInt(await methodChannel.invokeMethod<int>(method, arguments));

  static Future<bool> startService() async => await invokeBool('startService');

  static Future<bool> stopService() async => await invokeBool('stopService');

  static Future<bool> serviceStarted() async =>
      await invokeBool('serviceStarted');

  static Future<bool> setOptionJson(String optionJson) async =>
      await invokeBool('setOptionJson', optionJson);

  static Future<bool> setConfigJson(String configJson) async =>
      await invokeBool('setConfigJson', configJson);

  static Future<int> upLink() async => await invokeInt('upLink');

  static Future<int> downLink() async => await invokeInt('downLink');
}
