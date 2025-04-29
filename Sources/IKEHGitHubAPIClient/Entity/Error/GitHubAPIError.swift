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
    
    public var message: String?  // レスポンスのJSONに必ず含まれる
    public var errors: [Self.Error?]?
    public var status: String?
    public var documentationPath: String?
    
    public var statusCode: Int? {
        guard let status,
              let statusCode = Int(status) else {
            return nil
        }
        return statusCode
    }
}

// MARK: - LocalizedError

extension GitHubAPIError: LocalizedError {
    public var errorDescription: String? {
        return message
    }
}

// MARK: - Mock

extension GitHubAPIError {
    /// GitHubAPIErrorのMock
    public enum Mock {
        /// GitHubAPIErrorのMock: notModified
        public static var notModified: GitHubAPIError {
            .init(
                message: nil,
                errors: nil,
                status: "304",
                documentationPath: nil
            )
        }
        
        /// GitHubAPIErrorのMock: badCredentials
        public static var badCredentials: GitHubAPIError {
            .init(
                message: "Bad credentials",
                errors: nil,
                status: "401",
                documentationPath: "https://docs.github.com/rest"
            )
        }
        
        /// GitHubAPIErrorのMock: notFound
        public static var notFound: GitHubAPIError {
            .init(
                message: "Not Found",
                errors: nil,
                status: "404",
                documentationPath: "https://docs.github.com/rest/apps/oauth-applications#delete-an-app-authorization"
            )
        }
        
        /// GitHubAPIErrorのMock: validationFailed
        public static var validationFailed: GitHubAPIError {
            .init(
                message: "Validation Failed",
                errors: [
                    .init(resource: "Search", field: "q", code: "missing")
                ],
                status: "422",
                documentationPath: "https://docs.github.com/v3/search"
            )
        }
    }
}

// MARK: - JSONString

extension GitHubAPIError.Mock {
    enum JSONString {
        
        static let notModified = """
{}
"""
        
        static let badCredentials = """
{
  "message":"Bad credentials",
  "documentation_url":"https://docs.github.com/rest",
  "status":"401"
}
"""
        
        static let notFount = """
{
  "message": "Not Found",
  "documentation_url": "https://docs.github.com/rest/apps/oauth-applications#delete-an-app-authorization",
  "status": "404"
}
"""
        
        static let validationFailed = """
{
  "message": "Validation Failed",
  "errors": [
    {
      "resource": "Search",
      "field": "q",
      "code": "missing"
    }
  ],
  "documentation_url": "https://docs.github.com/v3/search",
  "status": "422"
}
"""
    }
}
