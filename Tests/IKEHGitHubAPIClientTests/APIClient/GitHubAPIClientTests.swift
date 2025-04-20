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
}

// MARK: - コールバックURLの受け取り処理のテスト

extension GitHubAPIClientTests {
    /// コールバックURLからセッションコードの抽出: 成功
    @MainActor
    func testExtactSessionCodeFromCallbackURLSuccess() async throws {

        // MARK: Given
        sut = .init(
            clientID: "",
            clientSecret: "",
            callbackURL: try XCTUnwrap(URL(string: "ikehgithubapi://callback")),
            scope: nil,
            urlSession: URLSessionStub()
        )
        let testLastLoginStateID = UUID().uuidString
        await sut.setLastLoginStateID(testLastLoginStateID)
        let testSessionCode = UUID().uuidString
        let testURL = try XCTUnwrap(URL(string: "ikehgithubapi://callback?code=\(testSessionCode)&state=\(testLastLoginStateID)"))
        
        // MARK: When
        let sessionCode = try await sut.extractSessionCodeFromCallbackURL(testURL)
        
        // MARK: Then
        XCTAssertEqual(
            testSessionCode,
            sessionCode
        )
    }
    
    /// コールバックURLからセッションコードの抽出: 失敗(クエリパラメータの不足)
    @MainActor
    func testExtactSessionCodeFromCallbackURLFailByInvalidURL() async throws {

        // MARK: Given
        sut = .init(
            clientID: "",
            clientSecret: "",
            callbackURL: try XCTUnwrap(URL(string: "ikehgithubapi://callback")),
            scope: nil,
            urlSession: URLSessionStub()
        )
        let testLastLoginStateID = UUID().uuidString
        await sut.setLastLoginStateID(testLastLoginStateID)
        let testSessionCode = UUID().uuidString
                                                      
        // MARK: When コールバックURLのcodeが不足している場合
        let testURLWithoutCode = try XCTUnwrap(URL(string: "ikehgithubapi://callback?state=\(testLastLoginStateID)"))
        do {
            _ = try await sut.extractSessionCodeFromCallbackURL(testURLWithoutCode)
        } catch {
            // MARK: Then
            guard let clientError = error as? GitHubAPIClientError else {
                XCTFail("unexpected error: \(error.localizedDescription)")
                return
            }
            XCTAssertTrue(clientError.isLoginError, "unexpected error: \(error.localizedDescription)")
        }
        
        // MARK: When コールバックURLのstateが不足している場合
        let testURLWithoutState = try XCTUnwrap(URL(string: "ikehgithubapi://callback?code=\(testSessionCode)"))
        do {
            _ = try await sut.extractSessionCodeFromCallbackURL(testURLWithoutState)
        } catch {
            // MARK: Then
            guard let clientError = error as? GitHubAPIClientError else {
                XCTFail("unexpected error: \(error.localizedDescription)")
                return
            }
            XCTAssertTrue(clientError.isLoginError, "unexpected error: \(error.localizedDescription)")
        }
    }
    
    /// コールバックURLからセッションコードの抽出: 失敗(lastLoginStateIDの不一致)
    @MainActor
    func testExtactSessionCodeFromCallbackURLFailByInvalidLastLoginStateID() async throws {
        // MARK: Given
        sut = .init(
            clientID: "",
            clientSecret: "",
            callbackURL: try XCTUnwrap(URL(string: "ikehgithubapi://callback")),
            scope: nil,
            urlSession: URLSessionStub()
        )
        let testLastLoginStateID = UUID().uuidString
        await sut.setLastLoginStateID(testLastLoginStateID)
                                                      
        // MARK: When
        let invalidLastLoginStateID = UUID().uuidString
        let testURLWithoutCode = try XCTUnwrap(URL(string: "ikehgithubapi://callback?code=xxx&state=\(invalidLastLoginStateID)"))
        do {
            _ = try await sut.extractSessionCodeFromCallbackURL(testURLWithoutCode)
        } catch {

            // MARK: Then
            guard let clientError = error as? GitHubAPIClientError else {
                XCTFail("unexpected error: \(error.localizedDescription)")
                return
            }
            XCTAssertTrue(clientError.isLoginError, "unexpected error: \(error.localizedDescription)")
        }
    }
}

