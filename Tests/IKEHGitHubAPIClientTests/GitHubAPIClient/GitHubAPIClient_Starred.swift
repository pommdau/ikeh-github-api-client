//
//  File.swift
//  IKEHGitHubAPIClient
//
//  Created by HIROKI IKEUCHI on 2025/04/22.
//

import Foundation
import XCTest
import HTTPTypes
@testable import IKEHGitHubAPIClient

final class GitHubAPIClient_Starred: XCTestCase {
    
    // MARK: - Property
    
    var sut: GitHubAPIClient!
    
    // MARK: - SetUp
    
    override func setUp() async throws {
        try await super.setUp()
    }
    
    // MARK: - Teardown
    
    override func tearDown() async throws {
        try await super.tearDown()
        sut = nil
    }
}

// MARK: - ユーザのスターしたリポジトリの一覧の取得のテスト

extension GitHubAPIClient_Starred {
    
    /// ユーザのスターしたリポジトリの一覧の取得: 成功
    func testStarredReposSuccess() async throws {
        // MARK: Given
        let testResponse: StarredReposResponse = .init(starredRepos: StarredRepo.Mock.random(count: 10))
        
        let urlSessionStub: URLSessionStub = .init(
            data: try JSONEncoder().encode(testResponse),
            response: .init(status: .ok))
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        let response = try await sut.fetchStarredRepos(userName: "userName")
        
        // MARK: Then
        XCTAssertEqual(response.starredRepos, testResponse.starredRepos)
    }
    
    /// ユーザのスターしたリポジトリの一覧の取得: 失敗(APIエラー)
    func testStarredReposFailedByAPIError() async throws {
        // MARK: Given
        let urlSessionStub = try URLSessionStub.create(with: GitHubAPIError.Mock.badCredentials)
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        do {
            _ = try await sut.fetchStarredRepos(userName: "userName")
            XCTFail("期待するエラーが検出されませんでした")
        } catch {
            // MARK: Then
            guard let clientError = error as? GitHubAPIClientError else {
                XCTFail("期待するエラーが検出されませんでした: \(error)")
                return
            }
            XCTAssertTrue(clientError.isAPIError, "期待するエラーが検出されませんでした: \(error)")
        }
    }
}

// MARK: - 指定したリポジトリのスター状態取得のテスト

extension GitHubAPIClient_Starred {
    
    /// ユーザのスターしたリポジトリの一覧の取得: 成功(スター済み)
    func testCheckIsRepoStarredSuccessWhenStarred() async throws {
        // MARK: Given
        let urlSessionStub: URLSessionStub = .init(
            data: try JSONEncoder().encode(NoBodyResponse()),
            response: .init(status: .ok))
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        let response = try await sut.checkIsRepoStarred(accessToken: "accessToken", ownerName: "ownerName", repoName: "repoName")
        
        // MARK: Then
        XCTAssertTrue(response)
    }
    
    /// ユーザのスターしたリポジトリの一覧の取得: 成功(未スター)
    func testCheckIsRepoStarredSuccessWhenUnstarred() async throws {
        // MARK: Given
        let urlSessionStub = try URLSessionStub.create(with: GitHubAPIError.Mock.notFound)
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        let response = try await sut.checkIsRepoStarred(accessToken: "accessToken", ownerName: "ownerName", repoName: "repoName")
        
        // MARK: Then
        XCTAssertFalse(response)
    }
    
    /// ユーザのスターしたリポジトリの一覧の取得: 失敗(APIエラー)
    func testCheckIsRepoStarredFailedByAPIError() async throws {
        // MARK: Given
        let urlSessionStub = try URLSessionStub.create(with: GitHubAPIError.Mock.badCredentials)
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        do {
            _ = try await sut.checkIsRepoStarred(accessToken: "accessToken", ownerName: "ownerName", repoName: "repoName")
            XCTFail("期待するエラーが検出されませんでした")
        } catch {
            // MARK: Then
            guard let clientError = error as? GitHubAPIClientError else {
                XCTFail("期待するエラーが検出されませんでした: \(error)")
                return
            }
            XCTAssertTrue(clientError.isAPIError, "期待するエラーが検出されませんでした: \(error)")
        }
    }
}


// MARK: - リポジトリをスター済みにする機能のテスト

extension GitHubAPIClient_Starred {
    
    /// リポジトリをスター済みにする: 成功
    func testStarRepoSuccess() async throws {
        // MARK: Given
        let urlSessionStub: URLSessionStub = .init(
            data: try JSONEncoder().encode(NoBodyResponse()),
            response: .init(status: .ok))
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        try await sut.starRepo(accessToken: "accessToken", ownerName: "ownerName", repoName: "repoName")
        
        // MARK: Then
        // エラーが投げられていなければOK
    }
    
    /// リポジトリをスター済みにする: 成功(すでにスター済みの場合)
    func testStarRepoSuccessWhenAlreadyStarred() async throws {
        // MARK: Given
        let urlSessionStub = try URLSessionStub.create(with: GitHubAPIError.Mock.notModified)
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        try await sut.starRepo(accessToken: "accessToken", ownerName: "ownerName", repoName: "repoName")
        
        // MARK: Then
        // エラーが投げられていなければOK
    }

    /// ユーザのスターしたリポジトリの一覧の取得: 失敗(APIエラー)
    func testStarReposFailedByAPIError() async throws {
        // MARK: Given
        let urlSessionStub = try URLSessionStub.create(with: GitHubAPIError.Mock.badCredentials)
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        do {
            try await sut.starRepo(accessToken: "accessToken", ownerName: "ownerName", repoName: "repoName")
            XCTFail("期待するエラーが検出されませんでした")
        } catch {
            // MARK: Then
            guard let clientError = error as? GitHubAPIClientError else {
                XCTFail("期待するエラーが検出されませんでした: \(error)")
                return
            }
            XCTAssertTrue(clientError.isAPIError, "期待するエラーが検出されませんでした: \(error)")
        }
    }
}

// MARK: - リポジトリを未スターにする機能のテスト

extension GitHubAPIClient_Starred {
    
    /// リポジトリを未スターにする: 成功
    func testUntarRepoSuccess() async throws {
        // MARK: Given
        let urlSessionStub: URLSessionStub = .init(
            data: try JSONEncoder().encode(NoBodyResponse()),
            response: .init(status: .ok))
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        try await sut.unstarRepo(accessToken: "accessToken", ownerName: "ownerName", repoName: "repoName")
        
        // MARK: Then
        // エラーが投げられていなければOK
    }
    
    /// リポジトリを未スターにする: 成功(すでに未スターの場合)
    func testUnstarRepoSuccessWhenAlreadyStarred() async throws {
        // MARK: Given
        let urlSessionStub = try URLSessionStub.create(with: GitHubAPIError.Mock.notModified)
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        try await sut.unstarRepo(accessToken: "accessToken", ownerName: "ownerName", repoName: "repoName")
        
        // MARK: Then
        // エラーが投げられていなければOK
    }

    /// ユーザのスターしたリポジトリの一覧の取得: 失敗(APIエラー)
    func testUnstarReposFailedByAPIError() async throws {
        // MARK: Given
        let urlSessionStub = try URLSessionStub.create(with: GitHubAPIError.Mock.badCredentials)
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        do {
            try await sut.unstarRepo(accessToken: "accessToken", ownerName: "ownerName", repoName: "repoName")
            XCTFail("期待するエラーが検出されませんでした")
        } catch {
            // MARK: Then
            guard let clientError = error as? GitHubAPIClientError else {
                XCTFail("期待するエラーが検出されませんでした: \(error)")
                return
            }
            XCTAssertTrue(clientError.isAPIError, "期待するエラーが検出されませんでした: \(error)")
        }
    }
}

