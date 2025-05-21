//
//  GitHubAPIClient+Starred.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/27.
//

import Foundation
import HTTPTypes

extension GitHubAPIClient {
    
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
    public func fetchStarredRepos(
        userName: String,
        accessToken: String? = nil,
        sort: String? = nil,
        direction: String? = nil,
        perPage: Int? = nil,
        page: Int? = nil
    ) async throws -> StarredReposResponse {
        let request = GitHubAPIRequest.FetchStarredRepos(
            accessToken: accessToken,
            userName: userName,
            sort: sort,
            direction: direction,
            perPage: perPage,
            page: page
        )
        let response = try await performRequest(with: request)
        return response
    }
        
    /// 指定したリポジトリのスター状態取得
    /// - Parameters:
    ///   - accessToken: アクセストークン
    ///   - owner: リポジトリのオーナ名
    ///   - repo: リポジトリ名
    /// - Returns: スター済みならTrue
    /// - SeeAlso: [GitHub Docs – Check if a repository is starred by the authenticated user](https://docs.github.com/ja/rest/activity/starring?apiVersion=2022-11-28#check-if-a-repository-is-starred-by-the-authenticated-user)
    public func checkIsRepoStarred(
        accessToken: String,
        owner: String,
        repo: String
    ) async throws -> Bool {
        let request = GitHubAPIRequest.CheckIsRepoStarredRequest(
            accessToken: accessToken,
            owner: owner,
            repo: repo
        )
        
        do {
            _ = try await performRequest(with: request)
        } catch {
            switch error {
            case let GitHubAPIClientError.apiError(apiError):
                if apiError.statusCode == HTTPResponse.Status.notFound.code {
                    return false // スターされていない
                }
                throw error
            default:
                throw error
            }
        }
        return true // スター済み
    }
        
    /// リポジトリをスター済みにする
    /// - Parameters:
    ///   - accessToken: アクセストークン
    ///   - owner: リポジトリのオーナー名
    ///   - repo: リポジトリ名
    /// - Note: すでにスター済みの場合はTrueを返す
    /// - SeeAlso: [GitHub Docs – Star a repository for the authenticated user](https://docs.github.com/ja/rest/activity/starring?apiVersion=2022-11-28#star-a-repository-for-the-authenticated-user)
    public func starRepo(accessToken: String, owner: String, repo: String) async throws {
        let request = GitHubAPIRequest.StarRepo(
            accessToken: accessToken,
            owner: owner,
            repo: repo
        )
        do {
            try await performRequest(with: request)
        } catch {
            switch error {
            case let GitHubAPIClientError.apiError(apiError):
                if apiError.statusCode == HTTPResponse.Status.notModified.code {
                    return // 変更なしは成功とみなす
                }
                throw error
            default:
                throw error
            }
        }
    }
    
    /// リポジトリを未スター状態にする
    /// - Parameters:
    ///   - accessToken: アクセストークン
    ///   - owner: リポジトリのオーナー名
    ///   - repo: リポジトリ名
    /// - Note: すでに未スター状態の場合はTrueを返す
    /// - SeeAlso: [GitHub Docs – Unstar a repository for the authenticated user](https://docs.github.com/ja/rest/activity/starring?apiVersion=2022-11-28#unstar-a-repository-for-the-authenticated-user)
    public func unstarRepo(accessToken: String, owner: String, repo: String) async throws {
        let request = GitHubAPIRequest.UnstarRepo(
            accessToken: accessToken,
            owner: owner,
            repo: repo
        )
        do {
            _ = try await performRequest(with: request)
        } catch {
            switch error {
            case let GitHubAPIClientError.apiError(apiError):
                if apiError.statusCode == HTTPResponse.Status.notModified.code {
                    return // 変更なしは成功とみなす
                }
                throw error
            default:
                throw error
            }
        }
    }
}
