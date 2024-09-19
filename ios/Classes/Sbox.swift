//
//  Sbox.swift
//  flutter_sbox
//
//  Created by local on 2024/9/10.
//

import Combine
import Libcore
import NetworkExtension

public class Sbox {
    private static let TAG = "Sbox/Sbox"
    public static var localizedDescription: String = "Sbox"
    private static var optionJson: String = "" // Conf.defaultOptionJson
    private static var configJson: String = "{}"
    private static var allJson: String = "{}"
    
    private static func debug(str: String) {
      //  debugPrint("\(TAG) \(str)")
    }
    
    public static func start() {
        debug(str: "start start")
        startService()
        debug(str: "start end")
    }
    
    private static func startService() {
        debug(str: "startService start")
        setAllJson(optionJson: getOptionJson(), configJson: getConfigJson())
        runBlocking {
            await VPN.connect()
            //            await VPNManager.connect(with: allJson)
        }
        debug(str: "startService end")
    }
    
    public static func stop() {
        debug(str: "stop start")
        stopService()
        debug(str: "stop end")
    }
    
    public static func stopService() {
        debug(str: "stopService start")
        VPN.disconnect()
        debug(str: "stopService end")
    }
    
    public static func serviceStarted() -> Bool {
        debug(str: "serviceStarted start")
        let serviceStarted = VPNManager.started
        debug(str: "serviceStarted end")
        return serviceStarted
    }
    
    public static func setOptionJson(_ currentOptionJson: String?) {
        debug(str: "setOptionJson start")
        if let currentOptionJson, !currentOptionJson.isEmpty {
            optionJson = currentOptionJson
            debug(str: "setOptionJson current: \(optionJson)")
        }
        debug(str: "setOptionJson end")
    }
    
    private static func getOptionJson() -> String {
        optionJson
    }
    
    public static func setConfigJson(_ currentConfigJson: String?) {
        debug(str: "setConfigJson start")
        if let currentConfigJson, !currentConfigJson.isEmpty {
            configJson = currentConfigJson
            debug(str: "setConfigJson current: \(configJson)")
        }
        debug(str: "setConfigJson end")
    }
    
    private static func getConfigJson() -> String {
        configJson
    }
    
    public static func setAllJson(optionJson: String, configJson: String) {
        debug(str: "setAllJson start")
        allJson = MobileBuildConfig(optionJson, configJson, nil)
        debug(str: "setAllJson current: \(allJson)")
        debug(str: "setAllJson end")
    }
    
    public static func getAllJson() -> String {
        allJson
    }
}
