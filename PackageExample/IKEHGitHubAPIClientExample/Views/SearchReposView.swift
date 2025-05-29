//
//  SearchReposView.swift
//  IKEHGitHubAPIClientExample
//
//  Created by HIROKI IKEUCHI on 2025/04/17.
//

import SwiftUI
import IKEHGitHubAPIClient

struct SearchReposView: View {
    
    private let tokenStore = TokenStore.shared
    private let gitHubAPIClient = GitHubAPIClient.shared
    
    let perPage = 10
    
    // MARK: リポジトリの検索
    @State private var searchedRepos: [IKEHGitHubAPIClient.Repo] = []
    @AppStorage("searchReposText")
    private var searchReposText = "SwiftUI"
    @State private var searchReposNextLink: RelationLink.Link?
    
    // MARK: 認証中のユーザのリポジトリの取得
    @State private var authenticatedUserRepos: [IKEHGitHubAPIClient.Repo] = []
    @State private var authenticatedUserReposNextLink: RelationLink.Link?
    
    // MARK: ユーザのリポジトリの取得
    @State private var userRepos: [IKEHGitHubAPIClient.Repo] = []
    @AppStorage("userReposText")
    private var userReposText = "pommdau"
    @State private var userReposNextLink: RelationLink.Link?
    
    // MARK: ユーザのスター済みリポジトリの取得
    @State private var starredRepos: [IKEHGitHubAPIClient.StarredRepo] = []
    @AppStorage("starredReposText")
    private var starredReposText = "pommdau"
    @State private var starredReposNextLink: RelationLink.Link?
    
    var body: some View {
        Form {
            searchReposSection()
            authenticatedUserReposSection()
            userReposSection()
            starredReposSection()
        }
    }
}

// MARK: - リポジトリの検索

extension SearchReposView {
    
    @ViewBuilder
    private func searchReposSection() -> some View {
        Section("Search Repos") {
            searchReposButton()
            searchReposLabel()
            searchReposMoreButton()
        }
    }
    
    @ViewBuilder
    private func searchReposButton() -> some View {
        HStack {
            TextField("Repo", text: $searchReposText)
            Button("Search") {                
                Task {
                    do {
                        let response = try await gitHubAPIClient.searchRepos(
                            query: searchReposText,
                            accessToken: tokenStore.accessToken,
                            perPage: perPage
                        )
                        searchedRepos = response.items
                        searchReposNextLink = response.relationLink?.next
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
        
    @ViewBuilder
    private func searchReposLabel() -> some View {
        VStack(alignment: .leading) {
            Text("Result")
                .font(.headline)
            
            Group {
                if searchedRepos.isEmpty {
                    Text("(Empty)")
                } else {
                    ForEach(searchedRepos) { repo in
                        Text(repo.fullName)
                    }
                }
            }
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    @ViewBuilder
    private func searchReposMoreButton() -> some View {
        Button("More") {
            Task {
                guard
                    let nextLink = searchReposNextLink,
                    let query = nextLink.queryItems["q"],
                    let page = nextLink.queryItems["page"],
                    let perPage = nextLink.queryItems["per_page"]
                else {
                    return
                }
                
                let response = try await gitHubAPIClient.searchRepos(
                    query: query,
                    accessToken: tokenStore.accessToken,
                    perPage: Int(perPage),
                    page: Int(page)
                )
                searchedRepos += response.items
                searchReposNextLink = response.relationLink?.next
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .disabled(searchReposNextLink == nil)
        .padding(.top, 4)
    }
}

// MARK: - 認証済みユーザのリポジトリの取得

extension SearchReposView {
    
    @ViewBuilder
    private func authenticatedUserReposSection() -> some View {
        Section("Login User Repos") {
            fetchAuthenticatedUserReposButton()
            fetchAuthenticatedUserReposLabel()
            fetchAuthenticatedUserReposMoreButton()
        }
    }
    
    @ViewBuilder
    private func fetchAuthenticatedUserReposButton() -> some View {
        HStack {
            TextField("User", text: $userReposText)
            Button("Fetch") {
                Task {
                    do {
                        let response = try await gitHubAPIClient.fetchAuthenticatedUserRepos(
                            accessToken: tokenStore.accessToken,
                            sort: "pushed",
                            perPage: 10
                        )
                        authenticatedUserRepos = response.items
                        authenticatedUserReposNextLink = response.relationLink?.next
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
        
    @ViewBuilder
    private func fetchAuthenticatedUserReposLabel() -> some View {
        VStack(alignment: .leading) {
            Text("Result")
                .font(.headline)
            
            Group {
                if authenticatedUserRepos.isEmpty {
                    Text("(Empty)")
                } else {
                    ForEach(authenticatedUserRepos) { repo in
                        Text(repo.fullName)
                            .lineLimit(1)
                    }
                }
            }
            .minimumScaleFactor(0.1)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    @ViewBuilder
    private func fetchAuthenticatedUserReposMoreButton() -> some View {
        Button("More") {
            Task {
                guard
                    let nextLink = authenticatedUserReposNextLink,
                    let page = nextLink.queryItems["page"],
                    let perPage = nextLink.queryItems["per_page"]
                else {
                    return
                }
                let response = try await gitHubAPIClient.fetchAuthenticatedUserRepos(
                    accessToken: tokenStore.accessToken,
                    sort: "pushed",
                    perPage: Int(perPage),
                    page: Int(page)
                )
                authenticatedUserRepos += response.items
                authenticatedUserReposNextLink = response.relationLink?.next
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .disabled(authenticatedUserReposNextLink == nil)
        .padding(.top, 4)
    }
}

// MARK: - ユーザのリポジトリの取得

extension SearchReposView {
    
    @ViewBuilder
    private func userReposSection() -> some View {
        Section("User Repos") {
            fetchUserReposButton()
            fetchUserReposLabel()
            fetchUserReposMoreButton()
        }
    }
    
    @ViewBuilder
    private func fetchUserReposButton() -> some View {
        HStack {
            TextField("User", text: $userReposText)
            Button("Fetch") {
                Task {
                    do {
                        let response = try await gitHubAPIClient.fetchUserRepos(
                            userName: userReposText,
                            accessToken: tokenStore.accessToken,
                            perPage: perPage,
                            page: nil
                        )
                        userRepos = response.items
                        userReposNextLink = response.relationLink?.next
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
        
    @ViewBuilder
    private func fetchUserReposLabel() -> some View {
        VStack(alignment: .leading) {
            Text("Result")
                .font(.headline)
            
            Group {
                if userRepos.isEmpty {
                    Text("(Empty)")
                } else {
                    ForEach(userRepos) { repo in
                        Text(repo.fullName)
                            .lineLimit(1)
                    }
                }
            }
            .minimumScaleFactor(0.1)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    @ViewBuilder
    private func fetchUserReposMoreButton() -> some View {
        Button("More") {
            Task {
                guard
                    let nextLink = userReposNextLink,
                    let page = nextLink.queryItems["page"],
                    let perPage = nextLink.queryItems["per_page"]
                else {
                    return
                }
                
                let response = try await gitHubAPIClient.fetchUserRepos(
                    userName: userReposText,
                    accessToken: tokenStore.accessToken,
                    perPage: Int(perPage),
                    page: Int(page)
                )
                userRepos += response.items
                userReposNextLink = response.relationLink?.next
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .disabled(userReposNextLink == nil)
        .padding(.top, 4)
    }
}

// MARK: - ユーザのスター済みリポジトリの取得

extension SearchReposView {
    
    @ViewBuilder
    private func starredReposSection() -> some View {
        Section("Starred Repos") {
            fetchStarredReposButton()
            starredReposLabel()
            fetchStarredReposMoreButton()
        }
    }
    
    @ViewBuilder
    private func fetchStarredReposButton() -> some View {
        HStack {
            TextField("User", text: $starredReposText)
            Button("Fetch") {
                Task {
                    do {
                        let response = try await gitHubAPIClient.fetchStarredRepos(
                            userName: starredReposText,
                            accessToken: tokenStore.accessToken,
                            perPage: perPage
                        )
                        starredRepos = response.starredRepos
                        starredReposNextLink = response.relationLink?.next
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
        
    @ViewBuilder
    private func starredReposLabel() -> some View {
        VStack(alignment: .leading) {
            Text("Result")
                .font(.headline)
            
            Group {
                if starredRepos.isEmpty {
                    Text("(Empty)")
                } else {
                    ForEach(starredRepos) { starredRepo in
                        Text(starredRepo.repo.fullName)
                            .lineLimit(1)
                    }
                }
            }
            .minimumScaleFactor(0.1)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    @ViewBuilder
    private func fetchStarredReposMoreButton() -> some View {
        Button("More") {
            Task {
                guard
                    let nextLink = starredReposNextLink,
                    let page = nextLink.queryItems["page"],
                    let perPage = nextLink.queryItems["per_page"]
                else {
                    return
                }
                let response = try await gitHubAPIClient.fetchStarredRepos(
                    userName: starredReposText,
                    accessToken: tokenStore.accessToken,
                    perPage: Int(perPage),
                    page: Int(page)
                )
                                                
                starredRepos += response.starredRepos
                starredReposNextLink = response.relationLink?.next
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .disabled(starredReposNextLink == nil)
        .padding(.top, 4)
    }
}

#Preview {
    SearchReposView()
}
