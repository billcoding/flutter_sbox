//
//  PacketTunnelProvider.swift
//  PacketTunnelProvider
//
//  Created by local on 2024/9/10.
//

import flutter_sbox
import NetworkExtension

class PacketTunnelProvider: NEPacketTunnelProvider {
    private let tunnel: VPNTunnelProvider = .init()
    
    override func startTunnel(options: [String: NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        print("running startTunnel >>>>>>>>>>>>>>>>>>>")
        Task { try await tunnel.startTunnel(options: options) }
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        Task { await tunnel.stopTunnel(with: reason) }
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        // Add code here to handle the message.
        if let handler = completionHandler {
            handler(messageData)
        }
    }
    
    override func sleep(completionHandler: @escaping () -> Void) {
        Task { await tunnel.sleep() }
    }
    
    override func wake() {
        tunnel.wake()
    }
}
