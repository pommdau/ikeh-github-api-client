//
//  GitHubAPIError.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/08.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//
//  ref: https://docs.github.com/en/rest/overview/resources-in-the-rest-api#client-errors

import Foundation

public struct GitHubAPIError: Codable, Sendable, Error {
    
    enum CodingKeys: String, CodingKey {
        case message
        case errors
        case status
        case documentationPath = "documentation_url"
    }
    
    public struct Error: Codable, Sendable {
        var resource: String
        var field: String
        var code: String
    }
    
    // MARK: - Property
    
    public var message: String  // レスポンスのJSONに必ず含まれる
    public var errors: [Self.Error?]?
    public var status: String
    public var documentationPath: String
    
    public var statusCode: Int? {
        guard let statusCode = Int(status) else {
            return nil
        }
        return statusCode
    }
}

extension GitHubAPIError: LocalizedError {
    public var errorDescription: String? {
        return message
    }
}
