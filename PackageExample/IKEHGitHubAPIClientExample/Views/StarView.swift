//
//  StarView.swift
//  IKEHGitHubAPIClientExample
//
//  Created by HIROKI IKEUCHI on 2025/04/17.
//

import SwiftUI
import IKEHGitHubAPIClient

struct StarView: View {
    
    private let tokenStore = TokenStore.shared
    private let gitHubAPIClient = GitHubAPIClient.shared
    
    @State private var repo: Repo?
    var repoLabelText: String {
        guard let repo else {
            return "(nil)"
        }
        return """
\(repo.fullName)
CreatedAt: \(repo.createdAt)
"""
    }

    @AppStorage("ownerName")
    private var ownerName = "pommdau"
    
    @AppStorage("repoName")
    private var repoName = "ikeh-github-api-client"
        
    var body: some View {
        Form {
            Section("Repo") {
                LabeledContent("Repo", value: repoLabelText)
            }
            searchRepoSection()
            starRepoSection()
        }
    }
}

// MARK: - SearchRepo

extension StarView {
    @ViewBuilder
    private func searchRepoSection() -> some View {
        Section("Search") {
            TextField("Owner", text: $ownerName)
            TextField("Repo", text: $repoName)
            Button("Search") {
                Task {
                    do {
                        repo = try await gitHubAPIClient.fetchRepo(
                            owner: ownerName,
                            repo: repoName,
                            accessToken: tokenStore.accessToken
                        )
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            Button("Open in Browser") {
                guard let url = URL(string: "https://github.com/\(ownerName)/\(repoName)") else {
                    return
                }
                UIApplication.shared.open(url)
            }
        }
    }
}

// MARK: - StarRepo

extension StarView {
        
    @ViewBuilder
    private func starRepoSection() -> some View {
        Section("Star") {
            checkIsRepoStarred()
            starButton()
            unstarButton()
        }
    }
    
    @ViewBuilder
    private func checkIsRepoStarred() -> some View {
        Button("Check Is Starred") {
            Task {
                guard let repo else {
                    return
                }
                do {
                    let result = try await gitHubAPIClient.checkIsRepoStarred(
                        accessToken: tokenStore.accessToken,
                        owner: repo.owner.login,
                        repo: repo.name
                    )
                    print("\(result ? "Starred" : "Not Starred")")
                } catch {
                    print(error.localizedDescription)
                    return
                }
            }
        }
    }
    
    @ViewBuilder
    private func starButton() -> some View {
        Button("Star") {
            Task {
                guard let repo else {
                    return
                }
                do {
                    try await gitHubAPIClient.starRepo(
                        accessToken: tokenStore.accessToken,
                        owner: repo.owner.login,
                        repo: repo.name
                    )
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @ViewBuilder
    private func unstarButton() -> some View {
        Button("Unstar") {
            Task {
                guard let repo else {
                    return
                }
                do {
                    try await gitHubAPIClient.unstarRepo(
                        accessToken: tokenStore.accessToken,
                        owner: repo.owner.login,
                        repo: repo.name
                    )
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    StarView()
}
