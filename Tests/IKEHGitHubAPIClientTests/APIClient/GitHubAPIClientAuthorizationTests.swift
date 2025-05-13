import XCTest
@testable import IKEHGitHubAPIClient

/// GitHubAPIClientの認証機能のテスト
final class GitHubAPIClientAuthorizationTests: XCTestCase {
    
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

extension GitHubAPIClientAuthorizationTests {
    /// コールバックURLからセッションコードの抽出: 成功
    @MainActor
    func testExtactSessionCodeFromCallbackURLSuccess() async throws {

        // MARK: Given
        sut = try .create()
        let testLastLoginStateID = UUID().uuidString
        await sut.setLastLoginStateID(testLastLoginStateID)
        let testSessionCode = UUID().uuidString
        let testURL = try XCTUnwrap(URL(string: "ikehgithubapi://callback?code=\(testSessionCode)&state=\(testLastLoginStateID)"))
        
        // MARK: When
        let sessionCode = try await sut.extractSessionCodeFromCallbackURL(testURL)
        
        // MARK: Then
        XCTAssertEqual(
            sessionCode,
            testSessionCode
        )
    }
    
    /// コールバックURLからセッションコードの抽出: 失敗(クエリパラメータの不足)
    @MainActor
    func testExtactSessionCodeFromCallbackURLFailByInvalidURL() async throws {

        // MARK: Given
        sut = try .create()
        let testLastLoginStateID = UUID().uuidString
        await sut.setLastLoginStateID(testLastLoginStateID)
        let testSessionCode = UUID().uuidString
                                                      
        // MARK: When コールバックURLのcodeが不足している場合
        let testURLWithoutCode = try XCTUnwrap(URL(string: "ikehgithubapi://callback?state=\(testLastLoginStateID)"))
        do {
            _ = try await sut.extractSessionCodeFromCallbackURL(testURLWithoutCode)
            XCTFail("期待するエラーが検出されませんでした")
        } catch {
            // MARK: Then
            guard let clientError = error as? GitHubAPIClientError else {
                XCTFail("期待するエラーが検出されませんでした: \(error)")
                return
            }
            XCTAssertTrue(clientError.isLoginError, "期待するエラーが検出されませんでした: \(error)")
        }
        
        // MARK: When コールバックURLのstateが不足している場合
        let testURLWithoutState = try XCTUnwrap(URL(string: "ikehgithubapi://callback?code=\(testSessionCode)"))
        do {
            _ = try await sut.extractSessionCodeFromCallbackURL(testURLWithoutState)
            XCTFail("期待するエラーが検出されませんでした")
        } catch {
            // MARK: Then
            guard let clientError = error as? GitHubAPIClientError else {
                XCTFail("期待するエラーが検出されませんでした: \(error)")
                return
            }
            XCTAssertTrue(clientError.isLoginError, "期待するエラーが検出されませんでした: \(error)")
        }
    }
    
    /// コールバックURLからセッションコードの抽出: 失敗(lastLoginStateIDの不一致)
    @MainActor
    func testExtactSessionCodeFromCallbackURLFailByInvalidLastLoginStateID() async throws {
        // MARK: Given
        sut = try .create()
        let testLastLoginStateID = UUID().uuidString
        await sut.setLastLoginStateID(testLastLoginStateID)
                                                      
        // MARK: When
        let invalidLastLoginStateID = UUID().uuidString
        let testURLWithoutCode = try XCTUnwrap(URL(string: "ikehgithubapi://callback?code=xxx&state=\(invalidLastLoginStateID)"))
        do {
            _ = try await sut.extractSessionCodeFromCallbackURL(testURLWithoutCode)
            XCTFail("期待するエラーが検出されませんでした")
        } catch {

            // MARK: Then
            guard let clientError = error as? GitHubAPIClientError else {
                XCTFail("期待するエラーが検出されませんでした: \(error)")
                return
            }
            XCTAssertTrue(clientError.isLoginError, "期待するエラーが検出されませんでした: \(error)")
        }
    }
}

// MARK: - トークン取得のテスト

extension GitHubAPIClientAuthorizationTests {
    
    /// トークン取得: 成功
    @MainActor
    func testFetchInitialTokenSuccess() async throws {
        // MARK: Given
        let testResponse: FetchInitialTokenResponse = .Mock.success
        let testData = try JSONEncoder().encode(testResponse)
        let urlSessionStub: URLSessionStub = .init(data: testData, response: .init(status: .ok))
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        let accessToken = try await sut.fetchInitialToken(sessionCode: "sessionCode")
        
        // MARK: Then
        XCTAssertEqual(
            accessToken,
            testResponse.accessToken
        )
    }

    /// トークン取得: 失敗(OAuthError)
    func testFetchInitialTokenFailedByOAuthError() async throws {
        // MARK: Given
        let urlSessionStub = try URLSessionStub.create(with: OAuthError.Mock.incorrectClientCredentials)
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        // 期待するエラーが投げられるかをテスト
        do {
            _ = try await sut.fetchInitialToken(sessionCode: "sessionCode")
        } catch {
            // MARK: Then
            guard let clientError = error as? GitHubAPIClientError else {
                XCTFail("期待するエラーが検出されませんでした: \(error)")
                return
            }
            XCTAssertTrue(clientError.isOauthAPIError, "期待するエラーが検出されませんでした: \(error)")
            return
        }
        XCTFail("期待するエラーが検出されませんでした")
    }

}

// MARK: - ログアウト

extension GitHubAPIClientAuthorizationTests {
    
    /// ログアウト: 成功
    func testLogoutSuccess() async throws {
        // MARK: Given
        let testData = try JSONEncoder().encode(NoBodyResponse())
        let urlSessionStub: URLSessionStub = .init(data: testData, response: .init(status: .ok))
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        try await sut.logout(accessToken: "accessToken")
        
        // MARK: Then
        // エラーが投げられていなければOK
    }

    /// ログアウト: 失敗(OAuthError)
    func testLogoutFailByGitHubAPIError() async throws {
        // MARK: Given
        let urlSessionStub = try URLSessionStub.create(with: GitHubAPIError.Mock.badCredentials)
        sut = try .create(urlSession: urlSessionStub)
                                
        // MARK: When
        
        // 期待するエラーが投げられるかをテスト
        do {
            try await sut.logout(accessToken: "accessToken")
        } catch {
            // MARK: Then
            guard let clientError = error as? GitHubAPIClientError else {
                XCTFail("期待するエラーが検出されませんでした: \(error)")
                return
            }
            XCTAssertTrue(clientError.isAPIError, "期待するエラーが検出されませんでした: \(error)")
            return
        }
        XCTFail("期待するエラーが検出されませんでした")
    }
}
