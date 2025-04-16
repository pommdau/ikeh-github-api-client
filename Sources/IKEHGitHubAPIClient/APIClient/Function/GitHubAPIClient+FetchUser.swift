import Foundation

extension GitHubAPIClient {
    
    /// 認証中のユーザを取得
    public func fetchLoginUser(accessToken: String) async throws -> LoginUser {
        let request = GitHubAPIRequest.FetchLoginUser(accessToken: accessToken)
        let response = try await performRequest(with: request)
        return response
    }
    
    /// ログイン名からユーザを取得
    public func fetchUser(accessToken: String, login: String) async throws -> User {
        let request = GitHubAPIRequest.FetchUser(accessToken: accessToken, userName: login)
        let response = try await performRequest(with: request)
        return response
    }
}
