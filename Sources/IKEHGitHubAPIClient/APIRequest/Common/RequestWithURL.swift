import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    /// クエリを含んだURL用の汎用リクエスト
    struct RequestWithURL<T: Decodable> {
        var accessToken: String?
        var rawURL: URL
    }
}

extension GitHubAPIRequest.RequestWithURL: GitHubAPIRequestProtocol {

    typealias Response = T
    
    var method: HTTPTypes.HTTPRequest.Method {
        .get
    }
    
    var baseURL: URL? {
        rawURL
    }
    
    var path: String {
        ""
    }
    
    var queryItems: [URLQueryItem] {
        []
    }
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.accept] = HTTPField.ConstValue.applicationVndGitHubJSON
        if let accessToken {
            headerFields[.authorization] = HTTPField.ConstValue.bearer(accessToken: accessToken)
        }
        headerFields[.xGithubAPIVersion] = HTTPField.ConstValue.xGitHubAPIVersion
        return headerFields
    }
    
    var body: Data? {
        nil
    }
}
