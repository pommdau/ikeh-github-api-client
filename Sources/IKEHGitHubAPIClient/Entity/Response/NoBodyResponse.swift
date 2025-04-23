//
//  File.swift
//  GitHubRESTAPI
//
//  Created by HIROKI IKEUCHI on 2025/04/10.
//

import Foundation

/// レスポンスのbodyが空のレスポンス
struct NoBodyResponse: Sendable, Equatable {}

extension NoBodyResponse: Codable {
    init(from decoder: Decoder) throws {}
}
