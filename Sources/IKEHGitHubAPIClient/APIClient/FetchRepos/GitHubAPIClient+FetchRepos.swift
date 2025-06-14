import Foundation

// MARK: - GitHubAPIClientFetchReposProtocol

extension GitHubAPIClient {
    
    /// リポジトリの検索
    /// - Parameters:
    ///   - query: 検索語句
    ///   - accessToken: アクセストークン
    ///   - sort: ソート基準: stars, forks, help-wanted-issues, updated (Default:  best match)
    ///   - order: ソート順: desc, asc (Default: desc)
    ///   - perPage: 1ページあたりの最大件数 (Default: 30 / Max: 100)
    ///   - page: 検索ページ番号 (Default: 1)
    /// - Returns: 該当するリポジトリの一覧
    /// - SeeAlso: [GitHub Docs – Search repositories](https://docs.github.com/en/rest/search/search?apiVersion=2022-11-28#search-repositories)
    public func searchRepos(
        query: String,
        accessToken: String? = nil,
        sort: String? = nil,
        order: String? = nil,
        perPage: Int? = nil,
        page: Int? = nil
    ) async throws -> SearchResponse<Repo> {
        let request = GitHubAPIRequest.SearchRepos(
            accessToken: accessToken,
            query: query,
            sort: sort,
            order: order,
            perPage: perPage,
            page: page
        )
        let response = try await performRequest(with: request)
        return response
    }
        
    /// 認証中のユーザのリポジトリ一覧を取得
    /// - Parameters:
    ///   - accessToken: アクセストークン（必須）
    ///   - visibility: リポジトリの可視性。 "all"（デフォルト）, "public", "private" から選択
    ///   - affiliation: 所有・コラボレーター・組織メンバーなどの所属。カンマ区切りで "owner", "collaborator", "organization_member" を指定（デフォルト: 全て）
    ///   - type: リポジトリの種類。 "all"（デフォルト）, "owner", "public", "private", "member" から選択
    ///   - sort: ソート基準。 "created", "updated", "pushed", "full_name"（デフォルト）から選択
    ///   - direction: ソート順。 "asc"（full_name時のデフォルト）, "desc"（デフォルト）から選択
    ///   - perPage: 1ページあたりの最大件数（デフォルト: 30, 最大: 100）
    ///   - page: ページ番号（デフォルト: 1）
    ///   - since: 指定した日時以降に作成されたリポジトリのみ取得（例: "2023-01-01T00:00:00Z"）
    ///   - before: 指定した日時以前に作成されたリポジトリのみ取得（例: "2023-01-01T00:00:00Z"）
    /// - Returns: 認証中ユーザのリポジトリ一覧
    /// - SeeAlso: [GitHub Docs – List repositories for the authenticated user](https://docs.github.com/ja/rest/repos/repos?apiVersion=2022-11-28#list-repositories-for-the-authenticated-user)
    public func fetchAuthenticatedUserRepos(
        accessToken: String,
        visibility: String? = nil,
        affiliation: String? = nil,
        type: String? = nil,
        sort: String? = nil,
        direction: String? = nil,
        perPage: Int? = nil,
        page: Int? = nil,
        since: String? = nil,
        before: String? = nil
    ) async throws -> ListResponse<Repo> {
        let request = GitHubAPIRequest.FetchAuthenticatedUserRepos(
            accessToken: accessToken,
            visibility: visibility,
            affiliation: affiliation,
            type: type,
            sort: sort,
            direction: direction,
            perPage: perPage,
            page: page,
            since: since,
            before: before
        )
        let response = try await performRequest(with: request)
        return response
    }
       
    /// 特定ユーザのパブリックリポジトリの一覧の取得
    /// - Parameters:
    ///   - userName: ユーザ名
    ///   - accessToken: アクセストークン
    ///   - type: 特定の属性のみを指定: all, owner, member (Default: owner)
    ///   - sort: ソート基準: created, updated, pushed, full_name (Default:  full_name)
    ///   - direction: ソート順: desc, asc (Default: desc)
    ///   - perPage: 1ページあたりの最大件数 (Default: 30 / Max: 100)
    ///   - page: 検索ページ番号 (Default: 1)
    /// - Returns: 特定ユーザのパブリックリポジトリの一覧
    /// - SeeAlso: [GitHub Docs – List repositories for a user](https://docs.github.com/ja/rest/repos/repos?apiVersion=2022-11-28#list-repositories-for-a-user)
    public func fetchUserRepos(
        userName: String,
        accessToken: String? = nil,
        type: String? = nil,
        sort: String? = nil,
        direction: String? = nil,
        perPage: Int? = nil,
        page: Int? = nil
    ) async throws -> ListResponse<Repo> {
        let request = GitHubAPIRequest.FetchUserRepos(
            accessToken: accessToken,
            userName: userName,
            type: type,
            sort: sort,
            direction: direction,
            perPage: perPage,
            page: page
        )
        let response = try await performRequest(with: request)
        return response
    }
    
    /// 特定のリポジトリの取得
    /// - Parameters:
    ///   - owner: リポジトリのオーナ名
    ///   - repo: リポジトリ名
    ///   - accessToken: アクセストークン
    /// - Returns: リポジトリの情報
    /// - SeeAlso: [GitHub Docs – Get a repository](https://docs.github.com/ja/rest/repos/repos?apiVersion=2022-11-28#get-a-repository)
    public func fetchRepo(
        owner: String,
        repo: String,
        accessToken: String? = nil
    ) async throws -> Repo {
        let request = GitHubAPIRequest.FetchRepo(accessToken: accessToken, owner: owner, repo: repo)
        let response = try await performRequest(with: request)
        return response
    }
}
