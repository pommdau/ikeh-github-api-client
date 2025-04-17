import Foundation
import HTTPTypes

// MARK: - FetchLoginUser
//  refs: https://docs.github.com/en/rest/users/users?apiVersion=2022-11-28

extension GitHubAPIRequest {
    /// 認証中のユーザ情報の取得
    struct FetchLoginUser {
        var accessToken: String
    }
}

extension GitHubAPIRequest.FetchLoginUser: GitHubAPIRequestProtocol {

    typealias Response = LoginUser
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        GitHubAPIEndpoints.apiBaseURL
    }
    
    var path: String {
        "/user"
    }
    
    var queryItems: [URLQueryItem] {
        []
    }
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.authorization] = HTTPField.ConstValue.bearer(accessToken: accessToken)
        headerFields[.accept] = HTTPField.ConstValue.applicationVndGitHubJSON
        headerFields[.xGithubAPIVersion] = HTTPField.ConstValue.xGitHubAPIVersion
        return headerFields
    }
    
    var body: Data? {
        nil
    }
}

// MARK: - FetchUser

//  refs: https://docs.github.com/ja/rest/users/users?apiVersion=2022-11-28#get-a-user

extension GitHubAPIRequest {
    struct FetchUser {
        var accessToken: String?
        var userName: String
    }
}

extension GitHubAPIRequest.FetchUser: GitHubAPIRequestProtocol {

    typealias Response = User
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        GitHubAPIEndpoints.apiBaseURL
    }
    
    var path: String {
        "/users/\(userName)"
    }
    
    var queryItems: [URLQueryItem] {
        []
    }
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        if let accessToken {
            headerFields[.authorization] = HTTPField.ConstValue.bearer(accessToken: accessToken)
        }
        headerFields[.accept] = HTTPField.ConstValue.applicationVndGitHubJSON
        headerFields[.xGithubAPIVersion] = HTTPField.ConstValue.xGitHubAPIVersion
        return headerFields
    }
    
    var body: Data? {
        nil
    }
}
