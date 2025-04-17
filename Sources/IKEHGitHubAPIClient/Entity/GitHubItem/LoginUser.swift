//
//  File.swift
//  IKEHGitHubAPIClient
//
//  Created by HIROKI IKEUCHI on 2025/04/16.
//

import Foundation

public struct LoginUser: GitHubItem {

    // MARK: - Decode Result
    
    enum CodingKeys: String, CodingKey {
        case rawID = "id"
        case login
        case avatarURL = "avatar_url"
        case url
        case htmlURL = "html_url"
        case name
        case location
        case email
        case bio
        case twitterUsername = "twitter_username"
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers
        case following
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
            
    public let rawID: Int
    public var login: String // e.g. "pommdau"
    public var avatarURL: String
    public var url: String
    public var htmlURL: String
    public var name: String? // e.g. "IKEH"
    public var location: String?
    public var email: String?
    public var bio: String?
    public var twitterUsername: String? // e.g. "ikeh1024"
    public var publicRepos: Int
    public var publicGists: Int
    public var followers: Int
    public var following: Int
    public var createdAt: String
    public var updatedAt: String
    
    public var twitterURL: URL? {
        guard let twitterUsername else {
            return nil
        }
        return URL(string: "https://x.com/\(twitterUsername)")
    }
}

// MARK: - Identifiable

extension LoginUser {
    public var id: SwiftID<Self> { "\(rawID)" }
}
