//
//  PacketTunnelProvider.swift
//  SboxPacketTunnel
//
//  Created by local on 2024/9/9.
//

import Libcore
import NetworkExtension

class PacketTunnelProvider: NEPacketTunnelProvider {
    public static let errorFile = FilePath.workingDirectory.appendingPathComponent("network_extension_error")
    
    private var boxService: LibboxBoxService!
    private var systemProxyAvailable = false
    private var systemProxyEnabled = false
    private var platformInterface: ExtensionPlatformInterface!
    private var config: String!
    
    override open func startTunnel(options: [String: NSObject]?) async throws {
        try? FileManager.default.removeItem(at: PacketTunnelProvider.errorFile)
        try? FileManager.default.removeItem(at: FilePath.workingDirectory.appendingPathComponent("TestLog"))
        
        let disableMemoryLimit = (options?["DisableMemoryLimit"] as? NSString as? String ?? "NO") == "YES"
        
        guard let config = options?["Config"] as? NSString as? String else {
            writeFatalError("(packet-tunnel) error: config not provided")
            return
        }
        guard let config = SingBox.setupConfig(config: config) else {
            writeFatalError("(packet-tunnel) error: config is invalid")
            return
        }
        self.config = config
        
        do {
            try FileManager.default.createDirectory(at: FilePath.workingDirectory, withIntermediateDirectories: true)
        } catch {
            writeFatalError("(packet-tunnel) error: create working directory: \(error.localizedDescription)")
            return
        }
        
        LibboxSetup(
            FilePath.sharedDirectory.relativePath,
            FilePath.workingDirectory.relativePath,
            FilePath.cacheDirectory.relativePath,
            false
        )
        
        var error: NSError?
        LibboxRedirectStderr(FilePath.cacheDirectory.appendingPathComponent("stderr.log").relativePath, &error)
        if let error {
            writeError("(packet-tunnel) redirect stderr error: \(error.localizedDescription)")
        }
        
        LibboxSetMemoryLimit(!disableMemoryLimit)
        
        if platformInterface == nil {
            platformInterface = ExtensionPlatformInterface(self)
        }
        writeMessage("(packet-tunnel) log server started")
        await startService()
    }
    
    private let TAG: String = "PacketTunnelProvider"
    func writeMessage(_ str: String) {
        debugPrint("\(TAG) \(str)")
    }
    
    func writeError(_ message: String) {
        writeMessage(message)
        try? message.write(to: PacketTunnelProvider.errorFile, atomically: true, encoding: .utf8)
    }
    
    public func writeFatalError(_ message: String) {
#if DEBUG
        NSLog(message)
#endif
        writeError(message)
        cancelTunnelWithError(NSError(domain: message, code: 0))
    }
    
    private func startService() async {
        let configContent = config
        var error: NSError?
        let service = LibboxNewService(configContent, platformInterface, &error)
        if let error {
            writeError("(packet-tunnel) error: create service: \(error.localizedDescription)")
            return
        }
        guard let service else {
            return
        }
        do {
            try service.start()
        } catch {
            writeError("(packet-tunnel) error: start service: \(error.localizedDescription)")
            return
        }
        boxService = service
    }
    
    private func stopService() {
        if let service = boxService {
            do {
                try service.close()
            } catch {
                writeError("(packet-tunnel) error: stop service: \(error.localizedDescription)")
            }
            boxService = nil
        }
        if let platformInterface {
            platformInterface.reset()
        }
    }
    
    func reloadService() async {
        writeMessage("(packet-tunnel) reloading service")
        reasserting = true
        defer {
            reasserting = false
        }
        stopService()
        await startService()
    }
    
    override open func stopTunnel(with reason: NEProviderStopReason) async {
        writeMessage("(packet-tunnel) stopping, reason: \(reason)")
        stopService()
    }
    
    override open func handleAppMessage(_ messageData: Data) async -> Data? {
        messageData
    }
    
    override open func sleep() async {
        if let boxService {
            boxService.pause()
        }
    }
    
    override open func wake() {
        if let boxService {
            boxService.wake()
        }
    }
}
