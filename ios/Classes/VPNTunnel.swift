//
//  VPNService.swift
//  flutter_sbox
//
//  Created by local on 2024/9/8.
//

import Foundation
import Libcore
import NetworkExtension

public class VPNTunnel: NEPacketTunnelProvider {
    private let TAG: String = "Sbox/VPNTunnel"
    private var boxService: LibboxBoxService!
    private var initialized: Bool = false
    private var started: Bool = false
    private var platformInterface: PlatformInterface!
    private func debug(str: String) {
        debugPrint("\(TAG) \(str)")
    }

    private func startInit() {
        if !initialized {
            LibboxSetup(
                FilePath.sharedDirectory.relativePath,
                FilePath.workingDirectory.relativePath,
                FilePath.cacheDirectory.relativePath,
                false
            )
            LibboxRedirectStderr(FilePath.cacheDirectory.appendingPathComponent("stderr.log").relativePath, nil)
        }
    }

    override public func startTunnel(options: [String: NSObject]? = nil) async throws{
        startInit()
        if platformInterface == nil {
            platformInterface = PlatformInterface(self)
        }
        boxService = LibboxNewService(Sbox.getAllJson(), platformInterface, nil)
        do {
            try boxService.start()
        } catch {
            debug(str: "startTunnel error: \(error.localizedDescription)")
        }
    }

    override open func stopTunnel(with reason: NEProviderStopReason) async {
        debug(str: "stopTunnel called reason: \(reason)")
        stopService()
    }

    private func stopService() {
        if let service = boxService {
            do {
                try service.close()
            } catch {
                debug(str: "stop service error: \(error.localizedDescription)")
            }
            boxService = nil
        }
        if let platformInterface {
            platformInterface.reset()
        }
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
