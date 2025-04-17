//
//  GitHubAPIClient.swift
//  IKEHGitHubAPIClientExample
//
//  Created by HIROKI IKEUCHI on 2025/04/17.
//

import Foundation
import IKEHGitHubAPIClient

extension GitHubAPIClient {
    static let shared: GitHubAPIClient = .init(
        clientID: GitHubAPICredentials.clientID,
        clientSecret: GitHubAPICredentials.clientSecret,
        // swiftlint:disable:next force_unwrapping
        callbackURL: URL(string: "ikeh-github-api-client-example://callback")!,
        scope: "repo" // ログインユーザのリポジトリを取得するためにスコープの設定が必要
    )
}
