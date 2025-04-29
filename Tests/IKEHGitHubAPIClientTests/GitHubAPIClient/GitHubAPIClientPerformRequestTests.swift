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

final class GitHubAPIClientPerformRequestTests: XCTestCase {
    
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

// MARK: - リクエスト送信のテスト
// 各処理を別途テストしているので、ここでは主な成功と失敗のみのテストのみとしている

extension GitHubAPIClientPerformRequestTests {
    
    /// 一連のリクエスト処理: 成功
    func testPerformRequestSuccess() async throws {
        // MARK: Given
        // 汎用関数のテスト用にレポジトリ取得のリクエストを利用している(任意のもので良い)
        let testRequest: GitHubAPIRequest.FetchRepo = .init(owner: "owner", repo: "repo")
        let testResponse: GitHubAPIRequest.FetchRepo.Response = Repo.Mock.random()
        let testData = try JSONEncoder().encode(testResponse)
        let urlSessionStub: URLSessionStub = .init(
            data: testData,
            response: .init(status: .ok)
        )
        sut = try .create(urlSession: urlSessionStub)

        // MARK: When
        let repo = try await sut.performRequest(with: testRequest)
        
        // MARK: Then
        XCTAssertEqual(repo, testResponse)
    }
    
    /// 一連のリクエスト処理: 失敗(APIからエラー返答)
    func testPerformRequestFailedByAPIError() async throws {
        // MARK: Given
        let urlSessionStub = try URLSessionStub.create(with: GitHubAPIError.Mock.badCredentials)
        sut = try .create(urlSession: urlSessionStub)

        // MARK: When
        do {
            let testRequest: GitHubAPIRequest.FetchRepo = .init(owner: "owner", repo: "repo")
            _ = try await sut.performRequest(with: testRequest)
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

// MARK: - リクエスト送信機能のテスト

extension GitHubAPIClientPerformRequestTests {
    
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
                XCTFail("期待するエラーが検出されませんでした: \(error)")
                return
            }
            XCTAssertTrue(clientError.isConnectionError, "期待するエラーが検出されませんでした: \(error)")
        }
    }
}

// MARK: - レスポンスの成否判定機能のテスト

extension GitHubAPIClientPerformRequestTests {
        
    /// checkResponse: 成功
    func testCheckResponseDefaultSuccess() async throws {
        // MARK: Given
        // MARK: When
        try GitHubAPIClient.checkResponseDefault(data: Data(), httpResponse: .init(status: .ok))
        
        // MARK: Then
        // エラーが投げられていなければOK
    }
    
    /// checkResponseDefault: 失敗(不正なステータスコード)
    func testCheckResponseDefaultFailedByInvalidStatusCode() async throws {
        // MARK: Given
        let testResponse: GitHubAPIError = .Mock.badCredentials
    
        // MARK: When
        do {
            try GitHubAPIClient.checkResponseDefault(
                data: try JSONEncoder().encode(testResponse),
                httpResponse: .init(status: .init(code: try XCTUnwrap(testResponse.statusCode)))
            )
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
    
    /// checkResponseForOAuth: 成功
    func testCheckResponseForOAuthSuccess() async throws {
        // MARK: Given
        // MARK: When
        try GitHubAPIClient.checkResponseDefault(data: Data(), httpResponse: .init(status: .ok))
        
        // MARK: Then
        // エラーが投げられていなければOK
    }
    
    /// checkResponseForOAuth: 失敗(レスポンスがエラー形式)
    func testCheckResponseForOAuthFailedByErrorResponse() async throws {
        // MARK: Given
        let testResponse: OAuthError = .Mock.incorrectClientCredentials
    
        // MARK: When
        do {
            try GitHubAPIClient.checkResponseForOAuth(
                data: try JSONEncoder().encode(testResponse),
                httpResponse: .init(status: .init(code: try XCTUnwrap(testResponse.statusCode)))
            )
            XCTFail("期待するエラーが検出されませんでした")
        } catch {
            // MARK: Then
            guard let clientError = error as? GitHubAPIClientError else {
                XCTFail("期待するエラーが検出されませんでした: \(error)")
                return
            }
            XCTAssertTrue(clientError.isOauthAPIError, "期待するエラーが検出されませんでした: \(error)")
        }
    }
}

// MARK: - レスポンスのデコード機能のテスト

extension GitHubAPIClientPerformRequestTests {
    
    // MARK: ページング情報の付与
    
    /// attachPagingIfNeeded: 成功
    func testAttachPagingIfNeededSuccess() async throws {
        // MARK: Given
        
        // テスト用のレスポンスBodyの作成
        let testRepos: [Repo] = Repo.Mock.random(count: 10)
        let testResponse: GitHubAPIRequest.SearchReposRequest.Response = .init(totalCount: testRepos.count, items: testRepos)
        
        // テスト用のレスポンスHeaderの作成
        var testHeaderFields = HTTPFields()
        testHeaderFields.append(
            HTTPField(
                name: try XCTUnwrap(HTTPField.Name("Link")),
                value: RelationLink.Mock.RawString.searchReposResponse
            )
        )
        let testHTTPResponse: HTTPResponse = .init(
            status: .ok,
            headerFields: testHeaderFields
        )
        XCTAssertNil(testResponse.relationLink)
        
        // MARK: When
        
        let responseWithPaging = try GitHubAPIClient.attachPagingIfNeeded(
            to: testResponse,
            from: testHTTPResponse
        )
        
        // MARK: Then
        XCTAssertNotNil(responseWithPaging.relationLink)
    }
    
    /// attachPagingIfNeeded: 成功(レスポンスヘッダにリンクの情報がない場合)
    func testAttachPagingIfNeededSuccessWhenPagingIsNil() async throws {
        // MARK: Given
        
        let testRepos: [Repo] = Repo.Mock.random(count: 10)
        let testResponse: GitHubAPIRequest.SearchReposRequest.Response = .init(totalCount: testRepos.count, items: testRepos)
        let testHTTPResponse: HTTPResponse = .init(
            status: .ok,
            headerFields: .init()
        )
        
        // MARK: When
        let responseWithPaging = try GitHubAPIClient.attachPagingIfNeeded(
            to: testResponse,
            from: testHTTPResponse
        )
        
        // MARK: Then
        // エラーが発生していない、かつページ情報が空の確認
        XCTAssertNil(responseWithPaging.relationLink)
    }

    // MARK: レスポンスのデコード処理のテスト
    
    func testDecodeResponseSuccess() async throws {
        // MARK: Given
        let testResponse: GitHubAPIRequest.FetchRepo.Response = Repo.Mock.random()
        let testData = try JSONEncoder().encode(testResponse)

        // MARK: When
        let response: GitHubAPIRequest.FetchRepo.Response = try GitHubAPIClient.decodeResponse(
            data: testData,
            httpResponse: .init(status: .ok)
        )
        
        // MARK: Then
        XCTAssertEqual(response, testResponse)
    }
    
    func testDecodeResponseForNodobyResponseSuccess() async throws {
        // MARK: Given
        let testResponse: NoBodyResponse = .init()
        let testData = try JSONEncoder().encode(testResponse)

        // MARK: When
        let response: NoBodyResponse = try GitHubAPIClient.decodeResponse(
            data: testData,
            httpResponse: .init(status: .ok)
        )
        
        // MARK: Then
        XCTAssertEqual(response, testResponse)
    }
    
    func testDecodeResponseFailed() async throws {
        // MARK: Given
        let testResponse = "testResponse"
        let testData = try JSONEncoder().encode(testResponse)

        // MARK: When
        do {
            let _: GitHubAPIRequest.FetchRepo.Response = try GitHubAPIClient.decodeResponse(
                data: testData,
                httpResponse: .init(status: .ok)
            )
            XCTFail("期待するエラーが検出されませんでした")
        } catch {
            // MARK: Then
            guard let clientError = error as? GitHubAPIClientError else {
                XCTFail("期待するエラーが検出されませんでした: \(error)")
                return
            }
            XCTAssertTrue(clientError.isResponseParseError, "期待するエラーが検出されませんでした: \(error)")
        }
    }
    
}
