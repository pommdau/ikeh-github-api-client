//
//  StarredReposResponse.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/26.
//

import Foundation

public struct ListResponse<Item: GitHubItem>: Sendable, PagingResponse {
    public var items: [Item]
    
    // MARK: PagingResponse
    public var relationLink: RelationLink? // ページング情報
}

// MARK: - Encodable

extension ListResponse: Encodable where Item: GitHubItem {
    public func encode(to encoder: Encoder) throws {
        // URLQueryItemがCodableではないので除外する
        var container = encoder.singleValueContainer()
        try container.encode(items)
    }
}

// MARK: - Decodable

extension ListResponse: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.items = try container.decode([Item].self)
    }
}
