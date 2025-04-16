import Foundation

public struct SearchResponse<Item>: Sendable, Codable, PagingResponse where Item: GitHubItem {

    // MARK: - レスポンスのBodyをDecodeして取得される情報
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }

    public let totalCount: Int
    public let items: [Item]
    
    // MARK: - レスポンスのHeaderから所得される情報
    
    public var relationLink: RelationLink? // ページング情報
}
