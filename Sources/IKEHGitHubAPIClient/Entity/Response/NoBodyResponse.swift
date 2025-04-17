//
//  File.swift
//  GitHubRESTAPI
//
//  Created by HIROKI IKEUCHI on 2025/04/10.
//

import Foundation

/// レスポンスのbodyが空のレスポンス
struct NoBodyResponse: Sendable {}

extension NoBodyResponse: Decodable {
    init(from decoder: Decoder) throws {}
}
