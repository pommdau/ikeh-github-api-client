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

extension GitHubAPIClient_FetchReposTests {
    
    /// searchRepos: 成功
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
}
