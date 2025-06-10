//
//  File.swift
//  IKEHGitHubAPIClient
//
//  Created by HIROKI IKEUCHI on 2025/06/09.
//

import Foundation

// MARK: - Authorization

/// GitHubAPIClientのプロトコル_Authorization
public protocol GitHubAPIClientAuthorizationProtocol {
    /// ブラウザでログインページを開く
    @MainActor
    func openLoginPageInBrowser() async throws

    /// 認証後のコールバックURLの情報からアクセストークンの取得を行う
    /// - Parameter url: 認証した後のコールバックURL
    /// - Returns: アクセストークン
    func recieveLoginCallBackURLAndFetchAccessToken(_ url: URL) async throws -> String
    
    /// ログアウト(サーバ上の認証情報の削除)
    /// - Parameter accessToken: アクセストークン
    func logout(accessToken: String) async throws
}

// MARK: - FetchRepos

/// GitHubAPIClientのプロトコル_FetchRepos
public protocol GitHubAPIClientFetchReposProtocol {
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
    func searchRepos(
        query: String,
        accessToken: String?,
        sort: String?,
        order: String?,
        perPage: Int?,
        page: Int?
    ) async throws -> SearchResponse<Repo>
    
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
    func fetchAuthenticatedUserRepos(
        accessToken: String,
        visibility: String?,
        affiliation: String?,
        type: String?,
        sort: String?,
        direction: String?,
        perPage: Int?,
        page: Int?,
        since: String?,
        before: String?
    ) async throws -> ListResponse<Repo>
    
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
    func fetchUserRepos(
        userName: String,
        accessToken: String?,
        type: String?,
        sort: String?,
        direction: String?,
        perPage: Int?,
        page: Int?
    ) async throws -> ListResponse<Repo>
    
    /// 特定のリポジトリの取得
    /// - Parameters:
    ///   - owner: リポジトリのオーナ名
    ///   - repo: リポジトリ名
    ///   - accessToken: アクセストークン
    /// - Returns: リポジトリの情報
    /// - SeeAlso: [GitHub Docs – Get a repository](https://docs.github.com/ja/rest/repos/repos?apiVersion=2022-11-28#get-a-repository)
    func fetchRepo(
        owner: String,
        repo: String,
        accessToken: String?
    ) async throws -> Repo
}

// MARK: - FetchUser

/// GitHubAPIClientのプロトコル_FetchUser
public protocol GitHubAPIClientFetchUserProtocol {
    /// 認証中のユーザを取得
    /// - Parameter accessToken: アクセストークン
    /// - Returns: 認証中のユーザ情報
    /// - SeeAlso: [GitHub Docs – Get the authenticated user](https://docs.github.com/en/rest/users/users?apiVersion=2022-11-28#get-the-authenticated-user)
    func fetchLoginUser(accessToken: String) async throws -> LoginUser

    /// ユーザ情報の取得
    /// - Parameters:
    ///   - accessToken: アクセストークン
    ///   - userName: ユーザ名
    /// - Returns: ユーザ情報
    /// - SeeAlso: [GitHub Docs – Get a user](https://docs.github.com/ja/rest/users/users?apiVersion=2022-11-28#get-a-user)
    func fetchUser(accessToken: String, userName: String) async throws -> User
}

// MARK: - Starred

/// GitHubAPIClientのプロトコル_Starred
public protocol GitHubAPIClientStarredProtocol {
    /// ユーザのスターしたリポジトリの一覧の取得
    /// - Parameters:
    ///   - userName: ユーザ名
    ///   - accessToken: アクセストークン
    ///   - sort: ソート基準: created, updated (Default: created)
    ///   - direction: ソート順: asc, desc (Default: desc)
    ///   - perPage: 1ページあたりの最大件数 (Default: 30 / Max: 100)
    ///   - page: 検索ページ番号 (Default: 1)
    /// - Returns: ユーザのスターしたリポジトリの一覧
    /// - SeeAlso: [GitHub Docs – List repositories starred by a user](https://docs.github.com/ja/rest/activity/starring?apiVersion=2022-11-28#list-repositories-starred-by-a-user)
    func fetchStarredRepos(
        userName: String,
        accessToken: String?,
        sort: String?,
        direction: String?,
        perPage: Int?,
        page: Int?
    ) async throws -> StarredReposResponse

    /// 指定したリポジトリのスター状態取得
    /// - Parameters:
    ///   - accessToken: アクセストークン
    ///   - owner: リポジトリのオーナ名
    ///   - repo: リポジトリ名
    /// - Returns: スター済みならTrue
    /// - SeeAlso: [GitHub Docs – Check if a repository is starred by the authenticated user](https://docs.github.com/ja/rest/activity/starring?apiVersion=2022-11-28#check-if-a-repository-is-starred-by-the-authenticated-user)
    func checkIsRepoStarred(
        accessToken: String,
        owner: String,
        repo: String
    ) async throws -> Bool

    /// リポジトリをスター済みにする
    /// - Parameters:
    ///   - accessToken: アクセストークン
    ///   - owner: リポジトリのオーナー名
    ///   - repo: リポジトリ名
    /// - Note: すでにスター済みの場合はTrueを返す
    /// - SeeAlso: [GitHub Docs – Star a repository for the authenticated user](https://docs.github.com/ja/rest/activity/starring?apiVersion=2022-11-28#star-a-repository-for-the-authenticated-user)
    func starRepo(
        accessToken: String,
        owner: String,
        repo: String
    ) async throws

    /// リポジトリを未スター状態にする
    /// - Parameters:
    ///   - accessToken: アクセストークン
    ///   - owner: リポジトリのオーナー名
    ///   - repo: リポジトリ名
    /// - Note: すでに未スター状態の場合はTrueを返す
    /// - SeeAlso: [GitHub Docs – Unstar a repository for the authenticated user](https://docs.github.com/ja/rest/activity/starring?apiVersion=2022-11-28#unstar-a-repository-for-the-authenticated-user)
    func unstarRepo(
        accessToken: String,
        owner: String,
        repo: String
    ) async throws
}

// MARK: - GitHubAPIClientProtocol

/// GitHubAPIClientのプロトコル
public protocol GitHubAPIClientProtocol:
    Actor,
    GitHubAPIClientAuthorizationProtocol,
    GitHubAPIClientFetchReposProtocol,
    GitHubAPIClientFetchUserProtocol,
    GitHubAPIClientStarredProtocol {
}
