import Foundation

/// GitHubAPIのクライアント
public final actor GitHubAPIClient: GitHubAPIClientProtocol {
    
    // MARK: - Property
    
    let clientID: String
    let clientSecret: String
    let callbackURL: URL
    let scope: String?
    let urlSession: URLSessionProtocol
    
    private(set) var lastLoginStateID: String = "" // 最後のログインセッションID
        
    // MARK: - LifeCycle
    
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
