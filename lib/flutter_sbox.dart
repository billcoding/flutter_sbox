import 'flutter_sbox_platform_interface.dart';

final class FlutterSbox {
  static Future<bool> start() {
    return FlutterSboxPlatform.instance.startService();
  }

  static Future<bool> stop() {
    return FlutterSboxPlatform.instance.stopService();
  }

  static Future<bool> serviceStarted() {
    return FlutterSboxPlatform.instance.serviceStarted();
  }

  static Future<bool> setOptionJson(String optionJson) {
    return FlutterSboxPlatform.instance.setOptionJson(optionJson);
  }

  static Future<bool> setConfigJson(String configJson) {
    return FlutterSboxPlatform.instance.setConfigJson(configJson);
  }
}
