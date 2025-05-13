//
//  RelationLinkTests.swift
//  IKEHGitHubAPIClient
//
//  Created by HIROKI IKEUCHI on 2025/05/14.
//

import XCTest
@testable import IKEHGitHubAPIClient

/// GitHubAPIClientの認証機能のテスト
final class RelationLinkTests: XCTestCase {
    
    // MARK: - Property
    
//    private var sut: GitHubAPIClient!
    
    // MARK: - SetUp
    
    override func setUp() async throws {
        try await super.setUp()
    }
    
    // MARK: - Teardown
    
    override func tearDown() async throws {
        try await super.tearDown()
//        sut = nil
    }
}

// MARK: - コールバックURLの受け取り処理のテスト

extension RelationLinkTests {

    /// rawStringからモデルクラスへのデコード: 成功
    func testMappingSuccess() async throws {
        
        // MARK: Given
        let testString = """
     <https://api.github.com/user/29433103/starred?sort=created&direction=desc&per_page=5&page=2>; rel=\"next\", <https://api.github.com/user/29433103/starred?sort=created&direction=desc&per_page=5&page=12>; rel=\"last\"
"""
        
        // MARK: When
        
        let relationLink = RelationLink.create(rawValue: testString)
        
        // MARK: Then
        
        let expected: RelationLink = .init(
            prev: nil,
            next: .init(
                id: "next",
                url: try XCTUnwrap(.init(string: "https://api.github.com/user/29433103/starred?sort=created&direction=desc&per_page=5&page=2")),
                queryItems: [
                    .init(name: "sort", value: "created"),
                    .init(name: "direction", value: "desc"),
                    .init(name: "per_page", value: "5"),
                    .init(name: "page", value: "2")
                ]
            ),
            last: .init(
                id: "last",
                url: try XCTUnwrap(.init(string: "https://api.github.com/user/29433103/starred?sort=created&direction=desc&per_page=5&page=12")),
                queryItems: [
                    .init(name: "sort", value: "created"),
                    .init(name: "direction", value: "desc"),
                    .init(name: "per_page", value: "5"),
                    .init(name: "page", value: "12")
                ]
            ),
            first: nil
        )
        XCTAssertEqual(relationLink, expected)                
    }
}
