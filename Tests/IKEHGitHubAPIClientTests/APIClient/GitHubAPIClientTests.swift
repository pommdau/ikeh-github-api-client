//
//  GitHubAPIClientTests.swift
//  IKEHGitHubAPIClient
//
//  Created by HIROKI IKEUCHI on 2025/04/17.
//

import XCTest
@testable import IKEHGitHubAPIClient

final class GitHubAPIClientTests: XCTestCase {
    
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
