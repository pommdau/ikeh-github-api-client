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
    
    /// ユーザ情報の取得: 成功
    func testStarredReposSuccess() async throws {
        // MARK: Given
        let testRepos = Repo.Mock.random(count: 10)
        let testResponse: StarredReposResponse = .init(repos: testRepos)
        
        let urlSessionStub: URLSessionStub = .init(
            data: try JSONEncoder().encode(testResponse),
            response: .init(status: .ok))
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        do {
            let response = try await sut.fetchStarredRepos(userName: "userName")
        } catch {
            fatalError(error.localizedDescription)
        }
        
        // MARK: Then
//        XCTAssertEqual(response.repos, testRepos)
    }
    
    /// ユーザ情報の取得: 失敗(APIエラー)
    func testFetchUserFailedByAPIError() async throws {
        // MARK: Given
        let urlSessionStub = try URLSessionStub.create(with: GitHubAPIError.Mock.badCredentials)
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        do {
            _ = try await sut.fetchUser(accessToken: "accessToken", login: "login")
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
