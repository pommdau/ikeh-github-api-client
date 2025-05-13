//
//  GitHubAPIClientError.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/08.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

public enum GitHubAPIClientError: Error {
    
    /// ログインに失敗
    case loginError(String)
    
    /// 認証トークンのエラー
    case tokenError(String)
    
    /// APIのリクエストの作成に失敗
    case invalidRequest
    
    /// 通信に失敗
    case connectionError(Error)
    
    /// レスポンスのデータのデコードに失敗
    case responseParseError(Error)
    
    // API実行後にエラーレスポンスを受け取った
    case apiError(GitHubAPIError)
    
    // OAuthのAPI実行後にエラーレスポンスを受け取った
    case oauthAPIError(OAuthError)
}

/// 型判定のためのUtils
/// - SeeAlso: [associated values抜きでのenumの比較をスマートにしたい #Swift - Qiita](https://qiita.com/kntkymt/items/b73f74c29fd4e399b6b7)
extension GitHubAPIClientError {
    var isLoginError: Bool {
        if case .loginError = self {
            return true
        }
        return false
    }
    var isTokenError: Bool {
        if case .tokenError = self {
            return true
        }
        return false
    }
    var isConnectionError: Bool {
        if case .connectionError = self {
            return true
        }
        return false
    }
    var isResponseParseError: Bool {
        if case .responseParseError = self {
            return true
        }
        return false
    }
    var isAPIError: Bool {
        if case .apiError = self {
            return true
        }
        return false
    }
    var isOauthAPIError: Bool {
        if case .oauthAPIError = self {
            return true
        }
        return false
    }
}

// MARK: - LocalizedError

extension GitHubAPIClientError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .loginError(let message):
            return "ログインに失敗しました: \(message)"
        case .tokenError(let message):
            return "APIの認証でエラーが発生しました: \(message)"
        case .invalidRequest:
            return "APIリクエストの作成に失敗しました"
        case .connectionError:
            return "通信エラー"
        case .responseParseError:
            return "データの取得に失敗しました"
        case .apiError(let gitHubAPIError):
            return "APIでエラーが発生しました: \(gitHubAPIError.localizedDescription)"
        case .oauthAPIError(let oAuthError):
            return "APIでエラーが発生しました: \(oAuthError.localizedDescription)"
        }
    }
}
