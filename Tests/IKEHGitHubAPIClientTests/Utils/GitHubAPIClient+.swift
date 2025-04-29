//
//  File.swift
//  IKEHGitHubAPIClient
//
//  Created by HIROKI IKEUCHI on 2025/04/22.
//

import Foundation
import XCTest
@testable import IKEHGitHubAPIClient

/// ユニットテスト用のファクトリメソッド
extension GitHubAPIClient {
    /// ユニットテスト用のファクトリメソッド
    static func create(urlSession: URLSessionProtocol = URLSessionStub()) throws -> GitHubAPIClient {
        .init(
            clientID: "clientID", // ダミー値
            clientSecret: "clientSecret", // ダミー値
            callbackURL: try XCTUnwrap(URL(string: "ikehgithubapi://callback")), // ダミー値
            scope: "repo", // ダミー値
            urlSession: urlSession
        )
    }
}
