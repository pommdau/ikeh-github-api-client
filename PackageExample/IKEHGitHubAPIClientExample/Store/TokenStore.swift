//
//  TokenStore.swift
//  IKEHGitHubAPIClientExample
//
//  Created by HIROKI IKEUCHI on 2025/04/17.
//

import SwiftUI

final actor TokenStore {
    static let shared = TokenStore()
    
    /// 実際はkeychain等セキュアな保存を推奨
    @AppStorage("TokenStore.accessToken")
    var accessToken: String = ""
    
    func setAccessToken(_ newValue: String) {
        accessToken = newValue
    }
}
