import Foundation
import HTTPTypes
import HTTPTypesFoundation

/// GitHub REST APIのリクエストのProtocol
protocol GitHubAPIRequestProtocol {
    
    // MARK: Response
    /// レスポンスのデータモデル
    associatedtype Response: Decodable
    /// レスポンスのエラー判定条件
    var responseFailType: ResponseFailType { get }
            
    // MARK: URL
    /// baseURL  e.g. "https://api.github.com"
    var baseURL: URL? { get }
    /// path e.g. "/search/repositories"
    var path: String { get }
    /// query parameters
    var queryItems: [URLQueryItem] { get }
    
    // MARK: Data
    
    /// method
    var method: HTTPRequest.Method { get }
    /// header
    var header: HTTPTypes.HTTPFields { get }
    /// body
    var body: Data? { get }
}

// MARK: - 共通処理

extension GitHubAPIRequestProtocol {
    
    // MARK: Response
    /// レスポンスのデータモデル
    var responseFailType: ResponseFailType {
        .statusCode
    }
    
    // MARK: URL
    
    /// クエリパラメータを含めたURL
    var url: URL? {
        guard
            let baseURL,
            var components = URLComponents(
                url: path.isEmpty ? baseURL : baseURL.appendingPathComponent(path),
                resolvingAgainstBaseURL: true
            )
        else {
            return nil
        }
        // 0個の場合末尾に?がついてしまうのを防止
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        return components.url
    }
    
    // MARK: - Request
    
    /// プロパティの値からHTTPRequestを作成
    func buildHTTPRequest() -> HTTPRequest? {
        guard let url else {
            return nil
        }
        print(url.absoluteString)
        return HTTPRequest(
            method: method,
            url: url,
            headerFields: header
        )
    }
}
