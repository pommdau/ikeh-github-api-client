//
//  LoginPage.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/30.
//
/*
 refs:
    https://docs.github.com/ja/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps
    scope: https://docs.github.com/ja/apps/oauth-apps/building-oauth-apps/scopes-for-oauth-apps
 */

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    /// ログインページのURLを作るためのクラス定義
    struct LoginPage {
        var clientID: String
        var callbackURL: URL
        var lastLoginStateID: String?
        var scope: String?
        
        var loginURL: URL? {
            self.url
        }
    }
}

extension GitHubAPIRequest.LoginPage: GitHubAPIRequestProtocol {
    
    // unused
    typealias Response = NoBodyResponse
    
    // unused
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        GitHubAPIEndpoints.oauthBaseURL
    }
    
    var path: String {
        "/login/oauth/authorize"
    }
    
    var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "client_id", value: clientID))
        queryItems.append(URLQueryItem(name: "redirect_uri", value: callbackURL.absoluteString))
        if let lastLoginStateID {
            queryItems.append(URLQueryItem(name: "state", value: lastLoginStateID))
        }
        if let scope {
            queryItems.append(URLQueryItem(name: "scope", value: scope))
        }
        
        return queryItems
    }
    
    // unused
    var header: HTTPTypes.HTTPFields {
        .init()
    }
    
    // unused
    var body: Data? {
        nil
    }
}
