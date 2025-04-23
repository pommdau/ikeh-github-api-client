import Foundation

/// GitHubAPIのクライアント
public final actor GitHubAPIClient {
    
    // MARK: - Property
    
    let clientID: String
    let clientSecret: String
    let callbackURL: URL
    let scope: String?
    let urlSession: URLSessionProtocol // TODO: Package外からは非公開にして、URLSessionを渡したい
    
    private(set) var lastLoginStateID: String = "" // 最後のログインセッションID
        
    // MARK: - LifeCycle
    
    public init(clientID: String, clientSecret: String, callbackURL: URL, scope: String? = nil) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.callbackURL = callbackURL
        self.scope = scope
        self.urlSession = URLSession.shared
    }
    
    /// URLSessionのDI用 TODO: check
    init(clientID: String, clientSecret: String, callbackURL: URL, scope: String? = nil, urlSession: URLSessionProtocol) {
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
