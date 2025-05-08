import Foundation

extension GitHubAPIClient {
        
    /// 認証中のユーザを取得
    /// - Parameter accessToken: アクセストークン
    /// - Returns: 認証中のユーザ情報
    /// - SeeAlso: [GitHub Docs – Get the authenticated user](https://docs.github.com/en/rest/users/users?apiVersion=2022-11-28#get-the-authenticated-user)
    public func fetchLoginUser(accessToken: String) async throws -> LoginUser {
        let request = GitHubAPIRequest.FetchLoginUser(accessToken: accessToken)
        let response = try await performRequest(with: request)
        return response
    }
                    
    /// ユーザ情報の取得
    /// - Parameters:
    ///   - accessToken: アクセストークン
    ///   - userName: ユーザ名
    /// - Returns: ユーザ情報
    /// - SeeAlso: [GitHub Docs – Get a user](https://docs.github.com/ja/rest/users/users?apiVersion=2022-11-28#get-a-user)
    public func fetchUser(accessToken: String, userName: String) async throws -> User {
        let request = GitHubAPIRequest.FetchUser(accessToken: accessToken, userName: userName)
        let response = try await performRequest(with: request)
        return response
    }
}
