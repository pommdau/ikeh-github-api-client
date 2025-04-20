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
    /// 固有型のID
    public var id: SwiftID<Self> { "\(rawID)" }
}

// MARK: - Mock

extension LoginUser {
    public enum Mock {
        public static let ikeh: LoginUser = .init(
            rawID: 29433103,
            login: "pommdau",
            avatarURL: "https://avatars.githubusercontent.com/u/29433103?v=4",
            url: "https://api.github.com/users/pommdau",
            htmlURL: "https://github.com/pommdau",
            name: "IKEH",
            location: "Osaka",
            email: nil,
            bio: nil,
            twitterUsername: "ikeh1024",
            publicRepos: 104,
            publicGists: 5,
            followers: 20,
            following: 7,
            createdAt: "2017-06-14T13:32:48Z",
            updatedAt: "2024-12-21T12:20:29Z"
        )
    }
}

// MARK: - JSONString

extension LoginUser.Mock {
    enum JSONString {
        static let octocat = #"""
 {
   "login": "octocat",
   "id": 1,
   "node_id": "MDQ6VXNlcjE=",
   "avatar_url": "https://github.com/images/error/octocat_happy.gif",
   "gravatar_id": "",
   "url": "https://api.github.com/users/octocat",
   "html_url": "https://github.com/octocat",
   "followers_url": "https://api.github.com/users/octocat/followers",
   "following_url": "https://api.github.com/users/octocat/following{/other_user}",
   "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
   "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
   "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
   "organizations_url": "https://api.github.com/users/octocat/orgs",
   "repos_url": "https://api.github.com/users/octocat/repos",
   "events_url": "https://api.github.com/users/octocat/events{/privacy}",
   "received_events_url": "https://api.github.com/users/octocat/received_events",
   "type": "User",
   "site_admin": false,
   "name": "monalisa octocat",
   "company": "GitHub",
   "blog": "https://github.com/blog",
   "location": "San Francisco",
   "email": "octocat@github.com",
   "hireable": false,
   "bio": "There once was...",
   "twitter_username": "monatheoctocat",
   "public_repos": 2,
   "public_gists": 1,
   "followers": 20,
   "following": 0,
   "created_at": "2008-01-14T04:33:35Z",
   "updated_at": "2008-01-14T04:33:35Z",
   "private_gists": 81,
   "total_private_repos": 100,
   "owned_private_repos": 100,
   "disk_usage": 10000,
   "collaborators": 8,
   "two_factor_authentication": true,
   "plan": {
     "name": "Medium",
     "space": 400,
     "private_repos": 20,
     "collaborators": 0
   }
 }
"""#
    }
}
