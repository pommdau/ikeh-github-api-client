//
//  DeleteAppAuthorization.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/22.
//
//  refs: https://docs.github.com/ja/rest/apps/oauth-applications?apiVersion=2022-11-28#delete-an-app-authorization

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    struct DeleteAppAuthorization {
        var accessToken: String
        var clientID: String
        var clientSecret: String
    }
}

extension GitHubAPIRequest.DeleteAppAuthorization: GitHubAPIRequestProtocol {

    typealias Response = NoBodyResponse
    
    var method: HTTPTypes.HTTPRequest.Method {
        .delete
    }
    
    var baseURL: URL? {
        GitHubAPIEndpoints.apiBaseURL
    }
    
    var path: String {
        "/applications/\(clientID)/grant"
    }
    
    var queryItems: [URLQueryItem] {
        []
    }
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.authorization] = HTTPField.ConstValue.aurhorization(clientID: clientID, clientSecret: clientSecret)
        headerFields[.contentType] = HTTPField.ConstValue.applicationJSON
        headerFields[.accept] = HTTPField.ConstValue.applicationVndGitHubJSON
        headerFields[.xGithubAPIVersion] = HTTPField.ConstValue.xGitHubAPIVersion
        return headerFields
    }
    
    var body: Data? {
        let body: [String: String] = [
            "access_token": accessToken
        ]
        do {
            return try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            assertionFailure("Failed to serialize JSON: \(error)")
            return nil
        }
    }
}
