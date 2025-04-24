import Foundation
import XCTest
@testable import IKEHGitHubAPIClient

final class GitHubAPIClient_FetchReposTests: XCTestCase {
    
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

// MARK: - リポジトリの検索のテスト

extension GitHubAPIClient_FetchReposTests {
    
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
        let response = try await sut.searchRepos(
            searchText: "searchText",
            accessToken: nil,
            sort: nil,
            order: nil,
            perPage: nil,
            page: nil
        )
        
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
                searchText: "searchText",
                accessToken: nil,
                sort: nil,
                order: nil,
                perPage: nil,
                page: nil
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
//
//extension GitHubAPIClient_FetchReposTests {
//    
//    /// リポジトリの検索: 成功
//    func testFetchUserReposSuccess() async throws {
//        // MARK: Given
//        let testResponse: ListResponse<Repo> = .init(items: Repo.Mock.random(count: 10))
//        
//        let urlSessionStub: URLSessionStub = .init(
//            data: try JSONEncoder().encode(testResponse),
//            response: .init(status: .ok))
//        sut = try .create(urlSession: urlSessionStub)
//        
//        // MARK: When
//        let response = try await sut.fetchUserRepos(
//            userName: "pommdau",
//            accessToken: nil,
//            type: nil,
//            sort: nil,
//            direction: nil,
//            perPage: nil,
//            page: nil
//        )
//        
//        // MARK: Then
//        XCTAssertEqual(response.items, testRepos)
//    }
//    /*
//    /// リポジトリの検索: 失敗(APIエラー)
//    func testSearchReposFailedByAPIError() async throws {
//        // MARK: Given
//        let urlSessionStub = try URLSessionStub.create(with: GitHubAPIError.Mock.badCredentials)
//        sut = try .create(urlSession: urlSessionStub)
//        
//        // MARK: When
//        do {
//            _ = try await sut.searchRepos(
//                searchText: "searchText",
//                accessToken: nil,
//                sort: nil,
//                order: nil,
//                perPage: nil,
//                page: nil
//            )
//            XCTFail("期待するエラーが検出されませんでした")
//        } catch {
//            // MARK: Then
//            guard let clientError = error as? GitHubAPIClientError else {
//                XCTFail("期待するエラーが検出されませんでした: \(error)")
//                return
//            }
//            XCTAssertTrue(clientError.isAPIError, "期待するエラーが検出されませんでした: \(error)")
//        }
//    }
//     */
//}
//
