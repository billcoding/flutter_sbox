//
//  SingBox.swift
//  flutter_sbox
//
//  Created by local on 2024/9/22.
//

import Foundation

class SingBox {
    static func setupConfig(config: String, mtu: Int = 9000) -> String? {
        guard
            let config = config.data(using: .utf8),
            let json = try? JSONSerialization
            .jsonObject(
                with: config,
                options: [.mutableLeaves, .mutableContainers]
            ) as? [String: Any]
        else {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: json) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}
