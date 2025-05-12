import Foundation

public struct SearchResponse<Item>: Sendable, Codable, PagingResponse where Item: GitHubItem {

    // MARK: - レスポンスのBodyをDecodeして取得される情報
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }

    public let totalCount: Int
    public let items: [Item]
    
    // MARK: - PagingResponse
    
    public var relationLink: RelationLink? // ページング情報
    
    // MARK: - LifeCycle
        
    /// イニシャライザ
    /// - Parameters:
    ///   - totalCount: 項目の総数
    ///   - items: 項目の配列
    ///   - relationLink: ページング情報
    public init(
        totalCount: Int,
        items: [Item],
        relationLink: RelationLink? = nil
    ) {
        self.totalCount = totalCount
        self.items = items
        self.relationLink = relationLink
    }
}
