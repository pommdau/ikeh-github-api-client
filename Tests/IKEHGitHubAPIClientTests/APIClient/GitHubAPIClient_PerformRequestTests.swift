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

final class GitHubAPIClient_PerformRequestTests: XCTestCase {
    
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

extension GitHubAPIClient_PerformRequestTests {
    
    func testSendRequestSuccess() async throws {
        // MARK: Given
        // 汎用関数のテスト用にレポジトリ取得のリクエストを利用している(任意のもので良い)
        let testRequest: GitHubAPIRequest.FetchRepo = .init(owner: "owner", repo: "repo")
        
        let testResponse: GitHubAPIRequest.FetchRepo.Response = Repo.Mock.random()
        let testData = try JSONEncoder().encode(testResponse)
        let testResponseStatus: HTTPResponse.Status = .ok
        let urlSessionStub: URLSessionStub = .init(
            data: testData,
            response: .init(status: testResponseStatus)
        )
        sut = try .create(urlSession: urlSessionStub)

        // MARK: When
        let (data, response): (Data, HTTPResponse) = try await sut.sendRequest(with: testRequest)
        
        // MARK: Then
        XCTAssertEqual(data, testData)
        XCTAssertEqual(response.status, testResponseStatus)
    }
    
    func testSendRequestFailedByCannotConnectToHost() async throws {
        // MARK: Given
        let testRequest: GitHubAPIRequest.FetchRepo = .init(owner: "owner", repo: "repo")
        let urlSessionStub: URLSessionStub = .init(
            error: URLError(.cannotConnectToHost)
        )
        sut = try .create(urlSession: urlSessionStub)

        // MARK: When
        do {
            _ = try await sut.sendRequest(with: testRequest)
            XCTFail("期待するエラーが検出されませんでした")
        } catch {
            // MARK: Then
            guard let clientError = error as? GitHubAPIClientError else {
                XCTFail("unexpected error: \(error.localizedDescription)")
                return
            }
            XCTAssertTrue(clientError.isConnectionError, "unexpected error: \(error.localizedDescription)")
        }
    }
}
