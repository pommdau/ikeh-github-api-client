import Foundation
import XCTest
@testable import IKEHGitHubAPIClient

/// テスト用のファクトリメソッド
extension URLSessionStub {
    static func create(with error: GitHubAPIError) throws -> URLSessionStub {
        let testData = try JSONEncoder().encode(error)
        return URLSessionStub(
            data: testData,
            response: .init(status: .init(code: try XCTUnwrap(error.statusCode)))
        )
    }
    
    static func create(with error: OAuthError) throws -> URLSessionStub {
        let testData = try JSONEncoder().encode(error)
        return URLSessionStub(
            data: testData,
            response: .init(status: .init(code: try XCTUnwrap(error.statusCode)))
        )
    }
}
