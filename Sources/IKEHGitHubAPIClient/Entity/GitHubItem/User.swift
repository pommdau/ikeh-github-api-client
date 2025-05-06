//
//  User.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/08.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

public struct User: GitHubItem {
    
    // MARK: - 検索結果から取得される値
    
    private enum CodingKeys: String, CodingKey {
        case rawID = "id"
        case login
        case name
        case avatarImagePath = "avatar_url"
        case htmlPath = "html_url"
        case location
        case bio
        case twitterUsername = "twitter_username"
        case publicRepos = "public_repos"
        case followers
        case following
    }

    public let rawID: Int
    public var login: String // e.g. "pommdau"
    public var name: String? // e.g. "IKEH"
    public var avatarImagePath: String
    public var htmlPath: String?  // e.g. https://github.com/apple
    public var location: String? // e.g. "Osaka"
    public var bio: String?
    public var twitterUsername: String? // e.g. "ikeh1024"
    public var publicRepos: Int?
    public var followers: Int?
    public var following: Int?
           
    // MARK: - Identifiable
    
    /// 固有型のID
    public var id: SwiftID<Self> { "\(rawID)" }
    
    // MARK: - Computed Property
    
    public var avatarImageURL: URL? {
        URL(string: avatarImagePath)
    }
    
    public var htmlURL: URL? {
        guard let htmlPath else {
            return nil
        }
        return URL(string: htmlPath)
    }
    
    public var twitterURL: URL? {
        guard let twitterUsername else {
            return nil
        }
        return URL(string: "https://x.com/\(twitterUsername)")
    }
    
    // MARK: - LifeCycle
    
    // swiftlint:disable function_default_parameter_at_end
    public init(
        rawID: Int,
        login: String,
        name: String? = nil,
        avatarImagePath: String,
        htmlPath: String? = nil,
        location: String? = nil,
        bio: String? = nil,
        twitterUsername: String? = nil,
        publicRepos: Int? = nil,
        followers: Int? = nil,
        following: Int? = nil
    ) {
        self.rawID = rawID
        self.login = login
        self.name = name
        self.avatarImagePath = avatarImagePath
        self.htmlPath = htmlPath
        self.location = location
        self.bio = bio
        self.twitterUsername = twitterUsername
        self.publicRepos = publicRepos
        self.followers = followers
        self.following = following
    }
    // swiftlint:enable function_default_parameter_at_end
}

// MARK: - Mock

extension User {
    /// UserのMock
    public enum Mock {
        /// 指定した個数のUserをランダムに生成
        /// - Parameter count: 要素数
        /// - Returns: 指定した個数のUserの配列
        public static func random(count: Int) -> [User] {
            var users: [User] = []
            while users.count < count {
                let newUser = User.Mock.random()
                // IDの被りがないかをチェック
                if users.map({ $0.id }).contains(newUser.id) {
                    continue
                }
                users.append(newUser)
            }
            
            return users
        }
        
        /// Userをランダムに生成
        /// - Returns: User
        public static func random() -> User {
            let randomID = Int.random(in: 1...Int.max)
            let randomLogin = ["alice", "bob", "charlie", "dave", "eve"].randomElement() ?? ""
            let randomName = ["Alice Johnson", "Bob Smith", "Charlie Brown", "Dave Williams", "Eve Adams"].randomElement() ?? ""
            let randomLocation = ["New York", "San Francisco", "Tokyo", "Berlin", "London"].randomElement() ?? ""
            let randomBio = ["iOS Developer", "Swift Enthusiast", "Open Source Contributor", "Tech Blogger", "GitHub Fan"].randomElement() ?? ""
            let randomTwitter = ["alice_dev", "bob_swift", "charlie_code", "dave_ios", "eve_git"].randomElement()
            
            return User(
                rawID: randomID,
                login: randomLogin,
                name: randomName,
                avatarImagePath: "https://avatars.githubusercontent.com/u/29433103?v=4",
                htmlPath: "https://github.com/pommdau",
                location: randomLocation,
                bio: randomBio,
                twitterUsername: randomTwitter,
                publicRepos: Int.random(in: 1...1000),
                followers: Int.random(in: 0...5000),
                following: Int.random(in: 0...5000)
            )
        }
    }
}

// MARK: - JSONString

extension User.Mock {
    enum JSONString {
        static let pommdau = #"""
 {
   "login":"pommdau",
   "id":29433103,
   "node_id":"MDQ6VXNlcjI5NDMzMTAz",
   "avatar_url":"https://avatars.githubusercontent.com/u/29433103?v=4",
   "gravatar_id":"",
   "url":"https://api.github.com/users/pommdau",
   "html_url":"https://github.com/pommdau",
   "followers_url":"https://api.github.com/users/pommdau/followers",
   "following_url":"https://api.github.com/users/pommdau/following{/other_user}",
   "gists_url":"https://api.github.com/users/pommdau/gists{/gist_id}",
   "starred_url":"https://api.github.com/users/pommdau/starred{/owner}{/repo}",
   "subscriptions_url":"https://api.github.com/users/pommdau/subscriptions",
   "organizations_url":"https://api.github.com/users/pommdau/orgs",
   "repos_url":"https://api.github.com/users/pommdau/repos",
   "events_url":"https://api.github.com/users/pommdau/events{/privacy}",
   "received_events_url":"https://api.github.com/users/pommdau/received_events",
   "type":"User",
   "user_view_type":"public",
   "site_admin":false,
   "name":"IKEH",
   "company":null,
   "blog":"",
   "location":"Osaka",
   "email":null,
   "hireable":null,
   "bio":null,
   "twitter_username":"ikeh1024",
   "public_repos":104,
   "public_gists":6,
   "followers":22,
   "following":7,
   "created_at":"2017-06-14T13:32:48Z",
   "updated_at":"2024-12-21T12:20:29Z"
 }
"""#
    }
}
