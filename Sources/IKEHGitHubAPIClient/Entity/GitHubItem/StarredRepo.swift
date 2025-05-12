//
//  StarredRepo.swift
//  IKEHGitHubAPIClient
//
//  Created by HIROKI IKEUCHI on 2025/05/12.
//

import Foundation

/// スター済みリポジトリ
public struct StarredRepo: GitHubItem {
    private enum CodingKeys: String, CodingKey {
        case starredAt = "starred_at"
        case repo
    }
    /// スター日時
    public var starredAt: String
    /// リポジトリ
    public var repo: Repo
    
    // MARK: - Identifiable
    
    public var id: Int { repo.id }
}
