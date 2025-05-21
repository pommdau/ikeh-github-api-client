import Foundation

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
        let request = GitHubAPIRequest.SearchReposRequest(
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
