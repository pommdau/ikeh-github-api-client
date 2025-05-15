import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// GitHubAPIのクライアント
public final actor GitHubAPIClient {
    
    // MARK: - Property
    
    /// GitHub APIのclientID
    let clientID: String
    /// GitHub APIのclientSecret
    let clientSecret: String
    /// GitHub APIのコールバックURL
    let callbackURL: URL
    /// APIの権限のスコープ
    let scope: String?
    /// URLSession
    let urlSession: URLSessionProtocol
    
    private(set) var lastLoginStateID: String = "" // 最後のログインセッションID
        
    // MARK: - LifeCycle
    
    /// initializer
    /// - Parameters:
    ///   - clientID: GitHub APIのclientID
    ///   - clientSecret: GitHub APIのclientSecret
    ///   - callbackURL: GitHub APIのコールバックURL
    ///   - scope: APIの権限のスコープ
    ///   - urlSession: URLSession
    public init(clientID: String, clientSecret: String, callbackURL: URL, scope: String? = nil, urlSession: URLSession = .shared) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.callbackURL = callbackURL
        self.scope = scope
        self.urlSession = URLSession.shared
    }
    
    init(clientID: String, clientSecret: String, callbackURL: URL, scope: String? = nil, urlSession: URLSessionProtocol = URLSession.shared) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.callbackURL = callbackURL
        self.scope = scope
        self.urlSession = urlSession
    }
    
    // MARK: - Setter
    
    func setLastLoginStateID(_ lastLoginStateID: String) {
        self.lastLoginStateID = lastLoginStateID
    }
}
