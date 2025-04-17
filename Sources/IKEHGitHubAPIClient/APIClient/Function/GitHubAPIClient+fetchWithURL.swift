import Foundation

extension GitHubAPIClient {
    /// クエリを含む完全なURLが分かっている場合に利用する、GETリクエストの通信
    public func fetchWithURL<Response: Decodable>(url: URL, accessToken: String? = nil) async throws -> Response {
        let request = GitHubAPIRequest.RequestWithURL<Response>(accessToken: accessToken, rawURL: url)
        let response = try await performRequest(with: request)
        return response
    }
}
