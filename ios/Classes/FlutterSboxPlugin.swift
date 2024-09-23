import Flutter
import Libcore
import UIKit

public class FlutterSboxPlugin: NSObject, FlutterPlugin {
    private var channel: FlutterMethodChannel?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "Sbox/FlutterSboxPlugin", binaryMessenger: registrar.messenger())
        let instance = FlutterSboxPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        instance.channel = channel
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "startService":
                Task {
                    let config = MobileGetAllJson(nil)
                    do {
                        try await VPNManager.shared.setup()
                        try await VPNManager.shared.connect(with: config, disableMemoryLimit: false)
                        result(true)
                    } catch {
                        result(false)
                    }
                }
            case "stopService":
                VPNManager.shared.disconnect()
                result(true)
            case "serviceStarted":
                result(MobileServiceStarted())
            case "setOptionJson":
                let optionJson = call.arguments as? String
                MobileSetOptionJson(optionJson)
                result(true)
            case "setConfigJson":
                let configJson = call.arguments as? String
                MobileSetConfigJson(configJson)
                result(true)
            case "upLink":
                let upLink = MobileUpLink()
                result(upLink)
            case "downLink":
                let downLink = MobileDownLink()
                result(downLink)
            default:
                result(FlutterMethodNotImplemented)
        }
    }
}
