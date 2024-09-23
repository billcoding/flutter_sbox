//
//  VPNManager.swift
//  flutter_sbox
//
//  Created by local on 2024/9/22.
//

import Combine
import Foundation
import Libcore
import NetworkExtension

class VPNManager {
    private var manager = NEVPNManager.shared()
    private var loaded = false
    static let shared: VPNManager = .init()
    
    func setup() async throws {
        guard !loaded else { return }
        loaded = true
        do {
            try await loadVPNPreference()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func loadVPNPreference() async throws {
        do {
            let managers = try await NETunnelProviderManager.loadAllFromPreferences()
            if let manager = managers.first {
                self.manager = manager
                return
            }
            let newManager = NETunnelProviderManager()
            let `protocol` = NETunnelProviderProtocol()
            `protocol`.providerBundleIdentifier = "com.example.flutterSboxExample.MyPacketTunnel"
            `protocol`.serverAddress = "localhost"
            newManager.protocolConfiguration = `protocol`
            newManager.localizedDescription = "Flutter Sbox"
            try await newManager.saveToPreferences()
            try await newManager.loadFromPreferences()
            manager = newManager
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func enableVPNManager() async throws {
        manager.isEnabled = true
        do {
            try await manager.saveToPreferences()
            try await manager.loadFromPreferences()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func connect(with config: String, disableMemoryLimit: Bool = false) async throws {
        do {
            try await enableVPNManager()
            try manager.connection.startVPNTunnel(options: [
                "Config": config as NSString,
                "DisableMemoryLimit": (disableMemoryLimit ? "YES" : "NO") as NSString,
            ])
            MobileStartCommandClient(nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func disconnect() {
        manager.connection.stopVPNTunnel()
        MobileStop()
    }
}
