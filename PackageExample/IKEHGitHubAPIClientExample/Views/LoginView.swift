//
//  LoginView.swift
//  IKEHGitHubAPIClientExample
//
//  Created by HIROKI IKEUCHI on 2025/04/17.
//

import SwiftUI
import IKEHGitHubAPIClient

struct LoginView: View {
    
    // MARK: - Property
    
    private let tokenStore = TokenStore.shared
    private let gitHubAPIClient = GitHubAPIClient.shared
    
    @State private var accessTokenForDisplay = ""
    @State private var searchText: String = ""
    
    @State private var loginUser: IKEHGitHubAPIClient.LoginUser?
    var loginUserText: String {
        guard let loginUser else {
            return "(nil)"
        }
        return "\(loginUser.name ?? "")(\(loginUser.login))"
    }
    
    // MARK: - View
        
    var body: some View {
        Form {
            authSection()
            loginUserSection()
        }
        .onAppear {
            Task {
                let accessToken = await tokenStore.accessToken
                if !accessToken.isEmpty {
                    accessTokenForDisplay = accessToken
                }
            }
        }
        .onOpenURL { url in
            Task {
                do {
                    let accessToken = try await gitHubAPIClient.handleLoginCallBackURLAndFetchAccessToken(url)
                    accessTokenForDisplay = accessToken
                    await tokenStore.setAccessToken(accessToken)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - 認証

extension LoginView {
    @ViewBuilder
    private func authSection() -> some View {
        Section("Auth") {
            LabeledContent("AccessToken", value: accessTokenForDisplay.isEmpty ? "(nil)" : accessTokenForDisplay)            
            loginButton()
            Button("Print AccessToken") {
                Task {
                    print("AccessToken: \(await tokenStore.accessToken)")
                }
            }
           logoutButton()
        }
    }
    
    @ViewBuilder
    private func loginButton() -> some View {
        Button("Log in") {
            Task {
                do {
                    try await gitHubAPIClient.openLoginPageInBrowser()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @ViewBuilder
    private func logoutButton() -> some View {
        Button("Logout", role: .destructive) {
            Task {
                if await tokenStore.accessToken.isEmpty {
                    print("AccessToken is empty.")
                    return
                }
                do {
                    try await gitHubAPIClient.logout(accessToken: tokenStore.accessToken)
                    print("Logout: OK")
                } catch {
                    print("Logout: Faild. \(error.localizedDescription)")
                    return
                }
                accessTokenForDisplay = ""
                await tokenStore.setAccessToken("")
                loginUser = nil
            }
        }
    }
}

// MARK: - Fetch LoginUser

extension LoginView {
    @ViewBuilder
    private func loginUserSection() -> some View {
        Section("LoginUser") {
            LabeledContent("LoginUser", value: loginUserText)
            Button("Fetch LoginUser") {
                Task {
                    do {
                        loginUser = try await gitHubAPIClient.fetchLoginUser(accessToken: tokenStore.accessToken)
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
