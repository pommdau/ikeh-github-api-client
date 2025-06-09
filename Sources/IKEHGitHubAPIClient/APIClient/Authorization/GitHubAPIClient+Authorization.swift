import Foundation

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - GitHubAPIClientAuthorizationProtocol

extension GitHubAPIClient {
        
    /// ブラウザでログインページを開く
    @MainActor
    public func openLoginPageInBrowser() async throws {
        // ログインセッションIDの作成
        let loginStateID = UUID().uuidString
        await setLastLoginStateID(loginStateID)
        
        let request = GitHubAPIRequest.LoginPage(
            clientID: clientID,
            callbackURL: callbackURL,
            lastLoginStateID: loginStateID,
            scope: scope
        )
        guard let url = request.loginURL else {
            throw GitHubAPIClientError.loginError("Failed to create URL")
        }
        
#if os(iOS)
        await UIApplication.shared.open(url)
#elseif os(macOS)
        NSWorkspace.shared.open(url)
#endif
    }
        
    ///  認証後のコールバックURLの情報からアクセストークンの取得を行う
    /// - Parameter url: 認証した後のコールバックURL
    /// - Returns: アクセストークン
    public func recieveLoginCallBackURLAndFetchAccessToken(_ url: URL) async throws -> String {
        let sessionCode = try await extractSessionCodeFromCallbackURL(url)
        return try await fetchInitialToken(sessionCode: sessionCode)
    }
        
    /// コールバックURLからログインセッションIDを抽出(初回認証時にのみ利用する一時的なcode)
    /// - Parameter url: 認証した後のコールバックURL
    /// - Returns: ログインセッションID
    func extractSessionCodeFromCallbackURL(_ url: URL) async throws -> String {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems,
            let state = queryItems.first(where: { $0.name == "state" })?.value,
            let sessionCode = queryItems.first(where: { $0.name == "code" })?.value
        else {
            throw GitHubAPIClientError.loginError("コールバックURLの値が不正です")
        }
        
        if  state != lastLoginStateID {
            // 最後に開いたログインページのコールバックではない場合
            throw GitHubAPIClientError.loginError("無効なログインセッションです")
        }
        
        return sessionCode
    }
        
    /// アクセストークンの取得
    /// - Parameter sessionCode: コールバックURLに含まれるセッションコード
    /// - Returns: アクセストークン
    func fetchInitialToken(sessionCode: String) async throws -> String {
        let request = GitHubAPIRequest.FetchInitialToken(
            clientID: clientID,
            clientSecret: clientSecret,
            sessionCode: sessionCode
        )
        let response = try await self.performRequest(with: request)
        return response.accessToken
    }
}

// MARK: - ログアウト

extension GitHubAPIClient {
    /// ログアウト(サーバ上の認証情報の削除)
    /// - Parameter accessToken: アクセストークン
    public func logout(accessToken: String) async throws {
        let request = GitHubAPIRequest.DeleteAppAuthorization(
            accessToken: accessToken,
            clientID: clientID,
            clientSecret: clientSecret
        )
        _ = try await self.performRequest(with: request)
    }
}
