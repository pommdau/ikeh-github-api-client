//
//  GitHubAPIRequest+Star.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/22.
//

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    
    struct FetchStarredRepos {
        
        // MARK: - Property
        
        var accessToken: String?
        
        var userName: String
        var page: Int?
        var perPage: Int?
        var sort: String? // "created" or "updated"
        var direction: String? // "desc" or "asc"
        
//        var path: String
                
        // MARK: - LifeCycle
            
        init(
            userName: String,
            accessToken: String? = nil,
            page: Int? = nil,
            perPage: Int? = nil,
            sort: String? = nil,
            direction: String? = nil
        ) {
            self.accessToken = accessToken
            self.userName = userName
            self.page = page
            self.perPage = perPage
            self.sort = sort
            self.direction = direction
//            self.path = "/users/\(userName)/starred"
        }
    }
}

extension GitHubAPIRequest.FetchStarredRepos: GitHubAPIRequestProtocol {

    typealias Response = StarredReposResponse
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        URL(string: "https://api.github.com")
    }
    
    var path: String {
        "/users/\(userName)/starred"
    }
    
    var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        
        if let sort {
            queryItems.append(URLQueryItem(name: "sort", value: sort))
        }
        
        if let direction {
            queryItems.append(URLQueryItem(name: "direction", value: direction))
        }
        if let page {
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        if let perPage {
            queryItems.append(URLQueryItem(name: "per_page", value: "\(perPage)"))
        }
        
        return queryItems
    }
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.accept] = "application/vnd.github.star+json" // Includes a timestamp of when the star was created.
        if let accessToken {
            headerFields[.authorization] = HTTPField.ConstValue.bearer(accessToken: accessToken)
        }
        headerFields[.xGithubAPIVersion] = HTTPField.ConstValue.xGitHubAPIVersion
        return headerFields
    }
    
    var body: Data? {
        nil
    }
}
