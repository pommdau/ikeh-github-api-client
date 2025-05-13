import Foundation
import XCTest
@testable import IKEHGitHubAPIClient

final class GitHubAPIClientFetchReposTests: XCTestCase {
    
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

// MARK: - リポジトリの検索のテスト

extension GitHubAPIClientFetchReposTests {
    
    /// リポジトリの検索: 成功
    func testSearchReposSuccess() async throws {
        // MARK: Given
        let testRepos = Repo.Mock.random(count: 10)
        let testResponse: SearchResponse<Repo> = .init(
            totalCount: testRepos.count,
            items: testRepos
        )
        
        let urlSessionStub: URLSessionStub = .init(
            data: try JSONEncoder().encode(testResponse),
            response: .init(status: .ok))
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        let response = try await sut.searchRepos(query: "query")
        
        // MARK: Then
        XCTAssertEqual(response.items, testRepos)
    }
    
    /// リポジトリの検索: 失敗(APIエラー)
    func testSearchReposFailedByAPIError() async throws {
        // MARK: Given
        let urlSessionStub = try URLSessionStub.create(with: GitHubAPIError.Mock.badCredentials)
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        do {
            _ = try await sut.searchRepos(
                query: "query"
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
}

// MARK: - 特定ユーザのリポジトリ一覧取得のテスト

extension GitHubAPIClientFetchReposTests {
    
    /// 特定ユーザのリポジトリ一覧取得: 成功
    func testFetchUserReposSuccess() async throws {
        // MARK: Given
        let testRepos = Repo.Mock.random(count: 10)
        let testResponse: ListResponse<Repo> = .init(items: testRepos)
        let urlSessionStub: URLSessionStub = .init(
            data: try JSONEncoder().encode(testResponse),
            response: .init(status: .ok))
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        let response = try await sut.fetchUserRepos(userName: "userName")
        
        // MARK: Then
        XCTAssertEqual(response.items, testRepos)
    }

    /// 特定ユーザのリポジトリ一覧取得: 失敗(APIエラー)
    func testFetchUserReposFailedByAPIError() async throws {
        // MARK: Given
        let urlSessionStub = try URLSessionStub.create(with: GitHubAPIError.Mock.badCredentials)
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        do {
            _ = try await sut.fetchUserRepos(userName: "userName")
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

// MARK: - 特定のリポジトリの情報取得のテスト

extension GitHubAPIClientFetchReposTests {
    
    /// 特定のリポジトリの情報取得のテスト: 成功
    func testFetchRepoSuccess() async throws {
        // MARK: Given
        let testResponse = Repo.Mock.random()
        let urlSessionStub: URLSessionStub = .init(
            data: try JSONEncoder().encode(testResponse),
            response: .init(status: .ok))
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        let response = try await sut.fetchRepo(owner: "owner", repo: "repo")
        
        // MARK: Then
        XCTAssertEqual(response, testResponse)
    }

    /// 特定のリポジトリの情報取得のテスト: 失敗(APIエラー)
    func testFetchRepoFailedByAPIError() async throws {
        // MARK: Given
        let urlSessionStub = try URLSessionStub.create(with: GitHubAPIError.Mock.badCredentials)
        sut = try .create(urlSession: urlSessionStub)
        
        // MARK: When
        do {
            _ = try await sut.fetchRepo(owner: "owner", repo: "repo")
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
