import Foundation

/// リポジトリのデータモデル。アーキテクチャのRepositoryと区別するためRepoの名称を使う
public struct Repo: GitHubItem {
    
    // MARK: - 検索結果から取得される値
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case isPrivate = "private"
        case owner
        case starsCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case language
        case htmlPath = "html_url"
        case websitePath = "homepage"
        case description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pushedAt = "pushed_at"
    }
    
    public let id: Int
    public var name: String  // e.g. "Tetris"
    public var fullName: String  // e.g. "dtrupenn/Tetris"
    public var isPrivate: Bool // プライベートリポジトリかどうか
    public var owner: User
    public var starsCount: Int
    public var watchersCount: Int
    public var forksCount: Int
    public var openIssuesCount: Int
    public var language: String?
    public var htmlPath: String  // リポジトリのURL
    public var websitePath: String?  // 設定したホームページ
    public var description: String?
    public var createdAt: String // e.g. "2015-10-23T21:15:07Z"
    public var updatedAt: String // e.g. "2025-02-02T06:17:34Z"
    public var pushedAt: String // e.g. "2025-03-28T04:22:29Z"
            
    // MARK: - Computed Property
    
    public var htmlURL: URL? {
        URL(string: htmlPath)
    }

    public var websiteURL: URL? {
        guard let websitePath else {
            return nil
        }
        return URL(string: websitePath)
    }
    
    // MARK: - LifeCycle
    
    // swiftlint:disable function_default_parameter_at_end
    public init(
        id: Int,
        name: String,
        fullName: String,
        isPrivate: Bool,
        owner: User,
        starsCount: Int,
        watchersCount: Int,
        forksCount: Int,
        openIssuesCount: Int,
        language: String? = nil,
        htmlPath: String,
        websitePath: String? = nil,
        description: String? = nil,
        createdAt: String,
        updatedAt: String,
        pushedAt: String
    ) {
        self.id = id
        self.name = name
        self.fullName = fullName
        self.isPrivate = isPrivate
        self.owner = owner
        self.starsCount = starsCount
        self.watchersCount = watchersCount
        self.forksCount = forksCount
        self.openIssuesCount = openIssuesCount
        self.language = language
        self.htmlPath = htmlPath
        self.websitePath = websitePath
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.pushedAt = pushedAt
    }
    // swiftlint:enable function_default_parameter_at_end
}

// MARK: - Mock

extension Repo {
    /// RepoのMock
    public enum Mock {
        // MARK: ランダム生成されるMock
        
        /// 指定した個数のRepoをランダムに生成
        /// - Parameter count: 要素数
        /// - Returns: 指定した個数のRepoの配列
        public static func random(count: Int) -> [Repo] {
            var repos: [Repo] = []
            while repos.count < count {
                let newRepo = Repo.Mock.random()
                // IDの被りがないかをチェック
                if repos.map({ $0.id }).contains(newRepo.id) {
                    continue
                }
                repos.append(newRepo)
            }
            
            return repos
        }
        
        /// Repoをランダムに生成
        /// - Returns: Repo
        public static func random() -> Repo {
            let randomID = Int.random(in: 1...Int.max)
            let randomName = ["Tetris", "Chess", "Snake", "Pong", "Breakout"].randomElement() ?? ""
            let randomOwner = User.Mock.random()
            let randomLanguage = ["Swift", "Python", "JavaScript", "C++", "Rust"].randomElement()
            
            return Repo(
                id: randomID,
                name: randomName,
                fullName: "\(randomOwner.login)/\(randomName)",
                isPrivate: Bool.random(),
                owner: randomOwner,
                starsCount: Int.random(in: 0...10000),
                watchersCount: Int.random(in: 0...5000),
                forksCount: Int.random(in: 0...3000),
                openIssuesCount: Int.random(in: 0...200),
                language: randomLanguage,
                htmlPath: "https://github.com/",
                websitePath: Bool.random() ? "https://\(randomName.lowercased()).com" : nil,
                description: "This is a random repository.",
                createdAt: ISO8601DateFormatter.shared.string(from: Date.random(inPastYears: 10)),
                updatedAt: ISO8601DateFormatter.shared.string(from: Date.random(inPastYears: 10)),
                pushedAt: ISO8601DateFormatter.shared.string(from: Date.random(inPastYears: 10))
            )
        }
    }
}

// MARK: - JSONString

extension Repo.Mock {
    enum JsonString {
        static let sample = """
{
  "id": 44838949,
  "node_id": "MDEwOlJlcG9zaXRvcnk0NDgzODk0OQ==",
  "name": "swift",
  "full_name": "swiftlang/swift",
  "private": false,
  "owner": {
    "login": "swiftlang",
    "id": 42816656,
    "node_id": "MDEyOk9yZ2FuaXphdGlvbjQyODE2NjU2",
    "avatar_url": "https://avatars.githubusercontent.com/u/42816656?v=4",
    "gravatar_id": "",
    "url": "https://api.github.com/users/swiftlang",
    "html_url": "https://github.com/swiftlang",
    "followers_url": "https://api.github.com/users/swiftlang/followers",
    "following_url": "https://api.github.com/users/swiftlang/following{/other_user}",
    "gists_url": "https://api.github.com/users/swiftlang/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/swiftlang/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/swiftlang/subscriptions",
    "organizations_url": "https://api.github.com/users/swiftlang/orgs",
    "repos_url": "https://api.github.com/users/swiftlang/repos",
    "events_url": "https://api.github.com/users/swiftlang/events{/privacy}",
    "received_events_url": "https://api.github.com/users/swiftlang/received_events",
    "type": "Organization",
    "user_view_type": "public",
    "site_admin": false
  },
  "html_url": "https://github.com/swiftlang/swift",
  "description": "The Swift Programming Language",
  "fork": false,
  "url": "https://api.github.com/repos/swiftlang/swift",
  "forks_url": "https://api.github.com/repos/swiftlang/swift/forks",
  "keys_url": "https://api.github.com/repos/swiftlang/swift/keys{/key_id}",
  "collaborators_url": "https://api.github.com/repos/swiftlang/swift/collaborators{/collaborator}",
  "teams_url": "https://api.github.com/repos/swiftlang/swift/teams",
  "hooks_url": "https://api.github.com/repos/swiftlang/swift/hooks",
  "issue_events_url": "https://api.github.com/repos/swiftlang/swift/issues/events{/number}",
  "events_url": "https://api.github.com/repos/swiftlang/swift/events",
  "assignees_url": "https://api.github.com/repos/swiftlang/swift/assignees{/user}",
  "branches_url": "https://api.github.com/repos/swiftlang/swift/branches{/branch}",
  "tags_url": "https://api.github.com/repos/swiftlang/swift/tags",
  "blobs_url": "https://api.github.com/repos/swiftlang/swift/git/blobs{/sha}",
  "git_tags_url": "https://api.github.com/repos/swiftlang/swift/git/tags{/sha}",
  "git_refs_url": "https://api.github.com/repos/swiftlang/swift/git/refs{/sha}",
  "trees_url": "https://api.github.com/repos/swiftlang/swift/git/trees{/sha}",
  "statuses_url": "https://api.github.com/repos/swiftlang/swift/statuses/{sha}",
  "languages_url": "https://api.github.com/repos/swiftlang/swift/languages",
  "stargazers_url": "https://api.github.com/repos/swiftlang/swift/stargazers",
  "contributors_url": "https://api.github.com/repos/swiftlang/swift/contributors",
  "subscribers_url": "https://api.github.com/repos/swiftlang/swift/subscribers",
  "subscription_url": "https://api.github.com/repos/swiftlang/swift/subscription",
  "commits_url": "https://api.github.com/repos/swiftlang/swift/commits{/sha}",
  "git_commits_url": "https://api.github.com/repos/swiftlang/swift/git/commits{/sha}",
  "comments_url": "https://api.github.com/repos/swiftlang/swift/comments{/number}",
  "issue_comment_url": "https://api.github.com/repos/swiftlang/swift/issues/comments{/number}",
  "contents_url": "https://api.github.com/repos/swiftlang/swift/contents/{+path}",
  "compare_url": "https://api.github.com/repos/swiftlang/swift/compare/{base}...{head}",
  "merges_url": "https://api.github.com/repos/swiftlang/swift/merges",
  "archive_url": "https://api.github.com/repos/swiftlang/swift/{archive_format}{/ref}",
  "downloads_url": "https://api.github.com/repos/swiftlang/swift/downloads",
  "issues_url": "https://api.github.com/repos/swiftlang/swift/issues{/number}",
  "pulls_url": "https://api.github.com/repos/swiftlang/swift/pulls{/number}",
  "milestones_url": "https://api.github.com/repos/swiftlang/swift/milestones{/number}",
  "notifications_url": "https://api.github.com/repos/swiftlang/swift/notifications{?since,all,participating}",
  "labels_url": "https://api.github.com/repos/swiftlang/swift/labels{/name}",
  "releases_url": "https://api.github.com/repos/swiftlang/swift/releases{/id}",
  "deployments_url": "https://api.github.com/repos/swiftlang/swift/deployments",
  "created_at": "2015-10-23T21:15:07Z",
  "updated_at": "2025-03-28T03:02:18Z",
  "pushed_at": "2025-03-28T04:22:29Z",
  "git_url": "git://github.com/swiftlang/swift.git",
  "ssh_url": "git@github.com:swiftlang/swift.git",
  "clone_url": "https://github.com/swiftlang/swift.git",
  "svn_url": "https://github.com/swiftlang/swift",
  "homepage": "https://swift.org",
  "size": 1232556,
  "stargazers_count": 68269,
  "watchers_count": 68269,
  "language": "C++",
  "has_issues": true,
  "has_projects": false,
  "has_downloads": true,
  "has_wiki": false,
  "has_pages": false,
  "has_discussions": false,
  "forks_count": 10441,
  "mirror_url": null,
  "archived": false,
  "disabled": false,
  "open_issues_count": 8110,
  "license": {
    "key": "apache-2.0",
    "name": "Apache License 2.0",
    "spdx_id": "Apache-2.0",
    "url": "https://api.github.com/licenses/apache-2.0",
    "node_id": "MDc6TGljZW5zZTI="
  },
  "allow_forking": true,
  "is_template": false,
  "web_commit_signoff_required": false,
  "topics": [],
  "visibility": "public",
  "forks": 10441,
  "open_issues": 8110,
  "watchers": 68269,
  "default_branch": "main",
  "score": 1
}
"""
    }
}

/*
 curl -L \
   -H "Accept: application/vnd.github+json" \
   -H "X-GitHub-Api-Version: 2022-11-28" \
   "https://api.github.com/search/repositories?q=swift&per_page=1"
 */
