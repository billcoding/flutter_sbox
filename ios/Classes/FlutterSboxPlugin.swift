import Flutter
import UIKit

public class FlutterSboxPlugin: NSObject, FlutterPlugin {
    private static let TAG = "Sbox/FlutterSboxPlugin"
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: TAG, binaryMessenger: registrar.messenger())
        let instance = FlutterSboxPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    private func debug(str: String) {
        debugPrint("\(FlutterSboxPlugin.TAG) \(str)")
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        @Sendable func mainResult(_ res: Any?) async {
            await MainActor.run {
                result(res)
            }
        }
        debug(str: "onMethodCall start")
        let method = call.method
        let arguments = call.arguments
        let argumentsString = arguments as? String
        debug(str: "onMethodCall method: \(method) arguments: \(String(describing: arguments))")
        switch method {
        case "startService":
              Sbox.start()
            result(true)
        case "stopService":
            Sbox.stop()
            result(true)
        case "serviceStarted":
            result(Sbox.serviceStarted())
        case "setOptionJson":
            if let optionJson = argumentsString {
                Sbox.setOptionJson(optionJson)
            }
            result(true)
        case "setConfigJson":
            if let configJson = argumentsString {
                Sbox.setConfigJson(configJson)
            }
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
        debug(str: "onMethodCall end")
    }
}
