//
//  File.swift
//  IKEHGitHubAPIClient
//
//  Created by HIROKI IKEUCHI on 2025/04/24.
//

import Foundation
import XCTest
@testable import IKEHGitHubAPIClient

/// GitHubAPIClientの認証機能のテスト
final class GitHubAPIClientTests: XCTestCase {
    
    // MARK: - Property
    
    private var sut: GitHubAPIClient!
    
    // MARK: - SetUp
    
    override func setUp() async throws {
        try await super.setUp()
    }
    
    // MARK: - Teardown
    
    override func tearDown() async throws {
        try await super.tearDown()
        sut = nil
    }
    
    func testExtactSessionCodeFromCallbackURLSuccess() async throws {        
        let repo = try JSONDecoder().decode(
            Repo.self,
            from: try XCTUnwrap(Repo.Mock.JsonString.sample.data(using: .utf8))
        )
        print(repo)
    }
}
