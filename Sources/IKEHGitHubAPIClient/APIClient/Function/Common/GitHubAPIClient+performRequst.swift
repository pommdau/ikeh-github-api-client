//
//  GitHubAPIClient+requst.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation
import HTTPTypes

// MARK: - Public

extension GitHubAPIClient {    
    /// リクエストの送信
    @discardableResult
    func performRequest<Request>(with request: Request) async throws -> Request.Response where Request: GitHubAPIRequestProtocol {
        let (data, httpResponse) = try await sendRequest(with: request)
        try Self.checkResponse(request: request, data: data, httpResponse: httpResponse)
        let response: Request.Response = try Self.decodeResponse(data: data, httpResponse: httpResponse)
        return response
    }
}

// MARK: - リクエストの送信

extension GitHubAPIClient {
    
    /// リクエストの送信
    func sendRequest<Request: GitHubAPIRequestProtocol>(with request: Request) async throws -> (Data, HTTPResponse) {
        // リクエストの作成
        guard let httpRequest = request.buildHTTPRequest() else {
            throw GitHubAPIClientError.invalidRequest
        }

        // リクエストの送信
        let (data, httpResponse): (Data, HTTPResponse)
        do {
            if let body = request.body {
                (data, httpResponse) = try await urlSession.upload(for: httpRequest, from: body)
            } else {
                (data, httpResponse) = try await urlSession.data(for: httpRequest)
            }
        } catch {
            throw GitHubAPIClientError.connectionError(error)
        }
        
        print(String(data: data, encoding: .utf8)!)
        
        return (data, httpResponse)
    }
}

// MARK: - レスポンスの成否判定

extension GitHubAPIClient {
                    
    private static func checkResponse(
        request: any GitHubAPIRequestProtocol,
        data: Data,
        httpResponse: HTTPResponse
    ) throws {
        switch request.responseFailType {
        case .statusCode:
            try Self.checkResponseDefault(data: data, httpResponse: httpResponse)
        case .responseBody:
            try Self.checkResponseForOAuth(data: data, httpResponse: httpResponse)
        }
    }
    
    /// レスポンスのステータスコードで成否を判定
    static func checkResponseDefault(data: Data, httpResponse: HTTPResponse) throws {
        // 200番台であれば成功
        if (200..<300).contains(httpResponse.status.code) {
            return
        }
        
        var errorResponse: GitHubAPIError
        do {
            errorResponse = try JSONDecoder().decode(GitHubAPIError.self, from: data)
        } catch {
            // 未対応のエラーレスポンス、もしくはデータが空
            print(String(data: data, encoding: .utf8)!)
            throw GitHubAPIClientError.responseParseError(error)
        }
//        errorResponse.statusCode = httpResponse.status.code
        throw GitHubAPIClientError.apiError(errorResponse)
    }
    
    /// レスポンスbodyの形式がエラーの形式かどうかで成否を判定(OAuthのリクエスト用)
    static func checkResponseForOAuth(data: Data, httpResponse: HTTPResponse) throws {
        /**
         OAuthの仕様で失敗時にも200番が返ってくる
         /そのためレスポンスがエラーの形式かどうかで確認する
         */
        var oAuthError: OAuthError
        do {
            oAuthError = try JSONDecoder().decode(OAuthError.self, from: data)
        } catch {
            // エラーの形式でないなら成功レスポンス
            return
        }
        oAuthError.statusCode = httpResponse.status.code
        throw GitHubAPIClientError.oauthAPIError(oAuthError)
    }
}

// MARK: - レスポンスのデコード

extension GitHubAPIClient {
    
    /// ページング情報に対応したResponseに対して、応答レスポンスにページング情報を含んでいればそれを付与する
    static func attachPagingIfNeeded<Response>(to response: Response, from httpResponse: HTTPResponse) throws -> Response {
        if var responseWithRelationLink = response as? PagingResponse,
           let link = httpResponse.headerFields.first(where: { $0.name.rawName == "Link" }) {
            // Responseページング情報を付与
            responseWithRelationLink.relationLink = RelationLink.create(rawValue: link.value)
            // 元の型に復元
            guard let responseWithRelationLink = (responseWithRelationLink as? Response) else {
                assertionFailure("ページング情報の取得に失敗しました")
                return response
            }
            return responseWithRelationLink
        } else {
            return response
        }
    }
    
    /// レスポンスをデータモデルにデコード
    static func decodeResponse<Response: Decodable>(data: Data, httpResponse: HTTPResponse) throws -> Response {
        var response: Response
        do {
            if Response.self == NoBodyResponse.self {
                response = try JSONDecoder().decode(Response.self, from: Data("{}".utf8)) // bodyが想定されたnilの場合はデコードエラー回避のためダミーのjson文字列を利用する
            } else {
                response = try JSONDecoder().decode(Response.self, from: data)
            }
        } catch {
            print(String(data: data, encoding: .utf8)!)
            throw GitHubAPIClientError.responseParseError(error)
        }
        response = try Self.attachPagingIfNeeded(to: response, from: httpResponse)
        return response
    }
}
