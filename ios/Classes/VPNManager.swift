//
//  VPNManaget.swift
//  flutter_sbox
//
//  Created by local on 2024/9/10.
//

import Libcore
import NetworkExtension

public class VPNManager {
    private static let TAG: String = "Sbox/VPNManager"
    private static var manager: NEVPNManager = .shared()
    public static var started: Bool = false
    
    private static func debug(str: String) {
        // debugPrint("\(TAG) \(str)")
    }
    
    private static func configure() async throws {
        do {
            let newManager = NETunnelProviderManager()
            let protoc = NETunnelProviderProtocol()
            protoc.serverAddress = "localhost"
            newManager.protocolConfiguration = protoc
            newManager.localizedDescription = Sbox.localizedDescription
            try await newManager.saveToPreferences()
            try await newManager.loadFromPreferences()
            manager = newManager
        } catch {
            debug(str: "load error: \(error.localizedDescription)")
        }
    }
    
    public static func connect() async {
        guard !started else { return }
        do {
            try await configure()
            let options: [String: NSString] = [
                "Config": MobileBuildConfig(defaultOptionJson, defaultConfigJson, nil) as NSString,
                "DisableMemoryLimit": "NO" as NSString
            ]
            try manager.connection.startVPNTunnel(options: options)
            started = true
        } catch {
            debug(str: "Connection error: \(error.localizedDescription)")
        }
    }
    
    public static func disconnect() {
        guard started else { return }
        manager.connection.stopVPNTunnel()
        started = false
    }
}
