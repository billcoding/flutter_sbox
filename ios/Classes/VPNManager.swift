//
//  VPNManaget.swift
//  flutter_sbox
//
//  Created by local on 2024/9/8.
//

import Foundation
import NetworkExtension

public class VPNManager {
    private static let TAG: String = "VPNManager"
    private static var manager: NEVPNManager = .shared()
    public static var started: Bool = false
    private static func debug(str: String) {
        debugPrint("\(TAG) \(str)")
    }

    private static func load() async throws {
        do {
            let managers = try await NETunnelProviderManager.loadAllFromPreferences()
            if let manager = managers.first {
                self.manager = manager
                return
            }
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

    private static func enable() async throws {
        manager.isEnabled = true
        do {
            try await manager.saveToPreferences()
            try await manager.loadFromPreferences()
        } catch {
            debug(str: "enable error: \(error.localizedDescription)")
        }
    }

    public static func connect(with config: String, disableMemoryLimit: Bool = false) async {
        guard started == false else { return }
        do {
            try await enable()
            try manager.connection.startVPNTunnel(options: [
                "Config": config as NSString,
                "DisableMemoryLimit": (disableMemoryLimit ? "YES" : "NO") as NSString,
            ])
            started = true
        } catch {
            debug(str: "connect error: \(error.localizedDescription)")
        }
    }

    public static func disconnect() {
        guard started else { return }
        manager.connection.stopVPNTunnel()
        started = false
    }
}
