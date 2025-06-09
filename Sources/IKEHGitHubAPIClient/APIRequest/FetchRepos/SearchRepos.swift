//
//  File.swift
//  IKEHGitHubAPIClient
//
//  Created by HIROKI IKEUCHI on 2025/04/16.
//

import Foundation
import HTTPTypes

extension GitHubAPIRequest {

    /// リポジトリの検索リクエスト
    /// - Parameters:
    ///   - accessToken: アクセストークン
    ///   - query: 検索語句
    ///   - sort: ソート基準  "stars", "forks", "help-wanted-issues", "updated"（デフォルトは"best match"）
    ///   - order: ソート順 "desc", "asc"（デフォルトは"desc"）
    ///   - perPage: 1ページあたりの最大件数（デフォルトは30、最大は100）
    ///   - page: 検索ページ番号（デフォルトは1）
    ///   - Returns: 該当するリポジトリの一覧
    /// - SeeAlso: [GitHub Docs > Search repositories](https://docs.github.com/en/rest/search/search?apiVersion=2022-11-28#search-repositories)
    struct SearchRepos {
        var accessToken: String?
        var query: String
        var sort: String?
        var order: String?
        var perPage: Int?
        var page: Int?
    }
}

extension GitHubAPIRequest.SearchRepos: GitHubAPIRequestProtocol {

    typealias Response = SearchResponse<Repo>
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        GitHubAPIEndpoints.apiBaseURL
    }
    
    var path: String {
        "/search/repositories"
    }
    
    var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "q", value: query))
        
        if let sort {
            queryItems.append(URLQueryItem(name: "sort", value: sort))
        }
        
        if let order {
            queryItems.append(URLQueryItem(name: "order", value: order))
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
        headerFields[.accept] = HTTPField.ConstValue.applicationVndGitHubJSON
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
