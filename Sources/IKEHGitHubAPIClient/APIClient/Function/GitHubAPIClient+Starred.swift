//
//  GitHubAPIClient+Starred.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/27.
//
//  refs: https://docs.github.com/ja/rest/activity/starring?apiVersion=2022-11-28

import Foundation
import HTTPTypes

extension GitHubAPIClient {
    
    public func fetchStarredRepos(
        userName: String,
        accessToken: String? = nil,
        sort: String? = nil,
        direction: String? = nil,
        perPage: Int? = nil,
        page: Int? = nil,
    ) async throws -> StarredReposResponse {
        let request = GitHubAPIRequest.FetchStarredRepos(
            accessToken: accessToken,
            userName: userName,
            sort: sort,
            direction: direction,
            perPage: perPage,
            page: page,
        )
        let response = try await performRequest(with: request)
        return response
    }
    
    public func checkIsRepoStarred(
        accessToken: String,
        ownerName: String,
        repoName: String
    ) async throws -> Bool {
//        try await Task.sleep(nanoseconds: 10_000_000_000) // 10s待機
        let request = GitHubAPIRequest.CheckIsRepoStarredRequest(
            accessToken: accessToken,
            ownerName: ownerName,
            repoName: repoName
        )
        
        do {
            _ = try await performRequest(with: request)
        } catch {
            switch error {
            case let GitHubAPIClientError.apiError(error):
                if error.statusCode == HTTPResponse.Status.notFound.code {
                    return false // スターされていない
                }
                throw error
            default:
                throw error
            }
        }
        return true // スター済み
    }
    
    public func starRepo(accessToken: String, ownerName: String, repoName: String) async throws {
        let request = GitHubAPIRequest.StarRepo(
            accessToken: accessToken,
            ownerName: ownerName,
            repoName: repoName
        )
        do {
            try await performRequest(with: request)
        } catch {
            switch error {
            case let GitHubAPIClientError.apiError(error):
                if error.statusCode == HTTPResponse.Status.notModified.code {
                    return // 変更なしは成功とみなす
                }
                throw error
            default:
                throw error
            }
        }
    }
    
    public func unstarRepo(accessToken: String, ownerName: String, repoName: String) async throws {
        let request = GitHubAPIRequest.UnstarRepo(
            accessToken: accessToken,
            ownerName: ownerName,
            repoName: repoName
        )
        do {
            _ = try await performRequest(with: request)
        } catch {
            switch error {
            case let GitHubAPIClientError.apiError(error):
                if error.statusCode == HTTPResponse.Status.notModified.code {
                    return // 変更なしは成功とみなす
                }
                throw error
            default:
                throw error
            }
        }
    }
}
