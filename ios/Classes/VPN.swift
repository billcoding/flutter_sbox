//
//  VPN.swift
//  flutter_sbox
//
//  Created by local on 2024/9/12.
//

import Foundation
import NetworkExtension

public class VPN {
    private static let TAG: String = "Sbox/VPN"
    private static let manager: NEVPNManager = .shared()
    
    private static func debug(str: String) {
        // debugPrint("\(TAG) \(str)")
    }
    
    private static func configure() async throws {
        let manager = NEVPNManager.shared()
        try await manager.loadFromPreferences()
        let protocolConfig = NETunnelProviderProtocol()
        protocolConfig.serverAddress = "127.0.0.1"
        manager.protocolConfiguration = protocolConfig
        manager.localizedDescription = "Your VPN Description"
        manager.isEnabled = true
        try await manager.saveToPreferences()
    }
    
    public static func connect() async {
        do {
            try await configure()
            let options = [
                "Config": defaultAllJson as NSObject,
                "DisableMemoryLimit": "NO" as NSObject
            ]
            try manager.connection.startVPNTunnel(options: options)
        } catch {
            debug(str: "Connection error: \(error.localizedDescription)")
        }
    }
    
    public static func disconnect() {
        manager.connection.stopVPNTunnel()
    }
}
