import Foundation
import HTTPTypes

/// URLSessionのStub
/// - SeeAlso: [iOS Unit Testing and UI Testing Tutorial > Download materials](https://www.kodeco.com/21020457-ios-unit-testing-and-ui-testing-tutorial)
final class URLSessionStub {
    
    // MARK: - Property
    
    private let stubbedData: Data?
    private let stubbedResponse: HTTPResponse?
    private let stubbedError: Error?
    
    // MARK: - LifeCycle
    
    /// ダミーの成功データを返すStubの作成
    init() {
        self.stubbedData = Data("Test Data".utf8)
        self.stubbedResponse = .init(status: .ok)
        self.stubbedError = nil
    }
    
    /// 指定したレスポンスを返すStubの作成
    init(data: Data? = nil, response: HTTPResponse? = nil) {
        self.stubbedData = data
        self.stubbedResponse = response
        self.stubbedError = nil
    }
    
    /// 指定したエラーをthrowするStubの作成
    init(error: Error? = nil) {
        self.stubbedData = nil
        self.stubbedResponse = nil
        self.stubbedError = error
    }
}

// MARK: - URLSessionProtocol

extension URLSessionStub: URLSessionProtocol {

    func data(for request: HTTPRequest) async throws -> (Data, HTTPResponse) {
        // エラーが設定されていればThrow
        if let stubbedError {
            throw stubbedError
        }
        
        // データを返す
        guard let stubbedData,
              let stubbedResponse else {
            fatalError("Invalid Property")
        }
        return (stubbedData, stubbedResponse)
    }

    func upload(for request: HTTPRequest, from bodyData: Data) async throws -> (Data, HTTPResponse) {
        if let stubbedError {
            throw stubbedError
        }
        guard let stubbedData,
              let stubbedResponse else {
            fatalError("Invalid Property")
        }
        return (stubbedData, stubbedResponse)
    }
}
