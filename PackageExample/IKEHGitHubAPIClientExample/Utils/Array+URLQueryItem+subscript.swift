//
//  Array+URLQueryItem_subscript.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/26.
//

import Foundation

/// [URLQueryItem]で次のようにアクセスできるようにする
/// e.g. nextLink.queryItems["page"]
extension [URLQueryItem] {
    subscript(_ key: String) -> String? {
        first(where: { $0.name == key })?.value
    }
}
