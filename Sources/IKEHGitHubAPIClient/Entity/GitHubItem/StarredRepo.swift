//
//  StarredRepo.swift
//  IKEHGitHubAPIClient
//
//  Created by HIROKI IKEUCHI on 2025/05/12.
//

import Foundation

/// スター済みリポジトリ
public struct StarredRepo: GitHubItem {
    
    // MARK: - Definition
    
    private enum CodingKeys: String, CodingKey {
        case starredAt = "starred_at"
        case repo
    }
    
    // MARK: - Property
    
    /// スター日時
    public var starredAt: String
    /// リポジトリ
    public var repo: Repo
    
    // MARK: - Identifiable
    
    /// id
    public var id: Int { repo.id }
    
    // MARK: - LifeCycle
    
    /// イニシャライザ
    public init(starredAt: String, repo: Repo) {
        self.starredAt = starredAt
        self.repo = repo
    }
}
