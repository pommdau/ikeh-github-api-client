//
//  CheckIsRepoStarredRequest.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/29.
//

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    struct CheckIsRepoStarredRequest {
        var accessToken: String
        var owner: String
        var repo: String
    }
}

extension GitHubAPIRequest.CheckIsRepoStarredRequest: GitHubAPIRequestProtocol {

    typealias Response = NoBodyResponse
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        GitHubAPIEndpoints.apiBaseURL
    }
    
    var path: String {
        "/user/starred/\(owner)/\(repo)"
    }
    
    var queryItems: [URLQueryItem] {
        []
    }
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.accept] = HTTPField.ConstValue.applicationVndGitHubJSON
        headerFields[.authorization] = HTTPField.ConstValue.bearer(accessToken: accessToken)
        headerFields[.xGithubAPIVersion] = HTTPField.ConstValue.xGitHubAPIVersion
        return headerFields
    }
    
    var body: Data? {
        nil
    }
}
