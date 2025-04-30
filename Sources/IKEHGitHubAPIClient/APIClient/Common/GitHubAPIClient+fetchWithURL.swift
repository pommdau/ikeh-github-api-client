import Foundation

extension GitHubAPIClient {
    /// クエリを含むURLが分かっている場合に利用する、GETリクエストの通信処理のUtil
    /// - Parameters:
    ///   - url: クエリを含むURL
    ///   - accessToken: アクセストークン
    /// - Returns: リクエスト結果
    public func fetchWithURL<Response: Decodable>(url: URL, accessToken: String? = nil) async throws -> Response {
        let request = GitHubAPIRequest.RequestWithURL<Response>(accessToken: accessToken, rawURL: url)
        let response = try await performRequest(with: request)
        return response
    }
}
