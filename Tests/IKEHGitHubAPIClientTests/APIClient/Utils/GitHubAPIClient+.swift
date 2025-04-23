//
//  File.swift
//  IKEHGitHubAPIClient
//
//  Created by HIROKI IKEUCHI on 2025/04/22.
//

import Foundation
import XCTest
@testable import IKEHGitHubAPIClient

extension GitHubAPIClient {
    /// テスト用のインスタンスを作成するためのUtilなファクトリメソッド
    /// (URLSessionProtocol以外はテストに影響がない)
    static func create(urlSession: URLSessionProtocol = URLSessionStub()) throws -> GitHubAPIClient {
        .init(
            clientID: "clientID",
            clientSecret: "clientSecret",
            callbackURL: try XCTUnwrap(URL(string: "ikehgithubapi://callback")),
            scope: "repo",
            urlSession: urlSession
        )
    }
}

