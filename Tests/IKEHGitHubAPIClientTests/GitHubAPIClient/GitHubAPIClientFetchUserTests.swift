import Foundation
import XCTest
@testable import IKEHGitHubAPIClient

final class GitHubAPIClientFetchUserTests: XCTestCase {
    
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

// MARK: - 認証ユーザ情報の取得のテスト

extension GitHubAPIClientFetchUserTests {
    
    /// 認証ユーザ情報の取得: 成功
    func testFetchLoginUserSuccess() async throws {
        // MARK: Given
        let testResponse: LoginUser = .Mock.ikeh
        
        let urlSessionStub: URLSessionStub = .init(
            data: try JSONEncoder().encode(testResponse),
            response: .init(status: .ok))
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        let response = try await sut.fetchLoginUser(accessToken: "accessToken")
        
        // MARK: Then
        XCTAssertEqual(response, testResponse)
    }
    
    /// 認証ユーザ情報の取得: 失敗(APIエラー)
    func testFetchLoginUserFailedByAPIError() async throws {
        // MARK: Given
        let urlSessionStub = try URLSessionStub.create(with: GitHubAPIError.Mock.badCredentials)
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        do {
            _ = try await sut.fetchLoginUser(accessToken: "accesstToken")
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

// MARK: - ユーザ情報の取得のテスト

extension GitHubAPIClientFetchUserTests {
    
    /// ユーザ情報の取得: 成功
    func testFetchUserSuccess() async throws {
        // MARK: Given
        let testResponse: User = .Mock.random()
        
        let urlSessionStub: URLSessionStub = .init(
            data: try JSONEncoder().encode(testResponse),
            response: .init(status: .ok))
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        let response = try await sut.fetchUser(accessToken: "accessToken", userName: "login")
        
        // MARK: Then
        XCTAssertEqual(response, testResponse)
    }
    
    /// ユーザ情報の取得: 失敗(APIエラー)
    func testFetchUserFailedByAPIError() async throws {
        // MARK: Given
        let urlSessionStub = try URLSessionStub.create(with: GitHubAPIError.Mock.badCredentials)
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        do {
            _ = try await sut.fetchUser(accessToken: "accessToken", userName: "login")
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
