//
//  StarRepo.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/03.
//

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    struct StarRepo {
        var accessToken: String
        var ownerName: String
        var repoName: String
    }
}

extension GitHubAPIRequest.StarRepo: GitHubAPIRequestProtocol {

    typealias Response = NoBodyResponse
    
    var method: HTTPTypes.HTTPRequest.Method {
        .put
    }
    
    var baseURL: URL? {
        GitHubAPIEndpoints.apiBaseURL
    }
    
    var path: String {
        "/user/starred/\(ownerName)/\(repoName)"
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
