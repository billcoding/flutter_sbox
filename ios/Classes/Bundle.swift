//
//  Bundle+Properties.swift
//  flutter_sbox
//
//  Created by local on 2024/9/22.
//

import Foundation

extension Bundle {
    var serviceIdentifier: String {
        (infoDictionary?["SERVICE_IDENTIFIER"] as? String)!
    }

    var baseBundleIdentifier: String {
        (infoDictionary?["BASE_BUNDLE_IDENTIFIER"] as? String)!
    }

    var displayName: String {
        (infoDictionary?["CFBundleDisplayName"] as? String)!
    }
}
