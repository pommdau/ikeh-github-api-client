//  refs: https://docs.github.com/ja/rest/repos/repos?apiVersion=2022-11-28#get-a-repository

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    struct FetchRepo {
        var accessToken: String?
        var owner: String // ユーザ名(login)
        var repo: String // リポジトリ名
    }
}

extension GitHubAPIRequest.FetchRepo: GitHubAPIRequestProtocol {

    typealias Response = Repo
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        GitHubAPIEndpoints.apiBaseURL
    }
    
    var path: String {
        "/repos/\(owner)/\(repo)"
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
