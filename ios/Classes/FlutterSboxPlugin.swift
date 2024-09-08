import Flutter
import UIKit

public class FlutterSboxPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "Sbox/FlutterSboxPlugin", binaryMessenger: registrar.messenger())
    let instance = FlutterSboxPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "start":
      result(true)
    case "stop":
      result(true)
    case "serviceStarted":
      result(true)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
