//
//  FetchAuthenticatedUserRepos.swift
//  IKEHGitHubAPIClient
//
//  Created by HIROKI IKEUCHI on 2025/05/29.
//
//  refs: https://docs.github.com/ja/rest/repos/repos?apiVersion=2022-11-28#list-repositories-for-a-user

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    struct FetchAuthenticatedUserRepos {
        var accessToken: String
        var visibility: String? // "all"(Default), "public", "private"
        var affiliation: String? // "owner,collaborator,organization_member"(Default), カンマ区切りで指定
        var type: String? // "all"(Default), "owner", "public", "private", "member"
        var sort: String? // "created", "updated", "pushed", "full_name"(Default)
        var direction: String? // "asc"(Default when full_name), "desc"(Default)
        var perPage: Int? // 1ページあたりの最大件数 (Default: 30 / Max: 100)
        var page: Int? // 検索ページ番号 (Default: 1)
        var since: String? // YYYY-MM-DDTHH:MM:SSZ / e.g. "2023-01-01T00:00:00Z"
        var before: String? // YYYY-MM-DDTHH:MM:SSZ / e.g. "2023-01-01T00:00:00Z"
    }
}

extension GitHubAPIRequest.FetchAuthenticatedUserRepos: GitHubAPIRequestProtocol {

    typealias Response = ListResponse<Repo>
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        GitHubAPIEndpoints.apiBaseURL
    }
    
    var path: String {
        "/user/repos"
    }
    
    var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        
        if let visibility {
            queryItems.append(URLQueryItem(name: "visibility", value: visibility))
        }
        if let affiliation {
            queryItems.append(URLQueryItem(name: "affiliation", value: affiliation))
        }
        if let type {
            queryItems.append(URLQueryItem(name: "type", value: type))
        }
        if let sort {
            queryItems.append(URLQueryItem(name: "sort", value: sort))
        }
        if let direction {
            queryItems.append(URLQueryItem(name: "direction", value: direction))
        }
        if let perPage {
            queryItems.append(URLQueryItem(name: "per_page", value: "\(perPage)"))
        }
        if let page {
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        if let since {
            queryItems.append(URLQueryItem(name: "since", value: since))
        }
        if let before {
            queryItems.append(URLQueryItem(name: "before", value: before))
        }
        
        return queryItems
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
