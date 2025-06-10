//
//  GitHubAPIClientStub.swift
//  IKEHGitHubAPIClient
//
//  Created by HIROKI IKEUCHI on 2025/06/09.
//

import Foundation

/// GitHubAPIのクライアント
public final actor GitHubAPIClientStub: GitHubAPIClientProtocol {
    
    // MARK: - Property
    
    // MARK: - Stubbed Response

    // GitHubAPIClientAuthorizationProtocol
    public var openLoginPageInBrowserStubbedResponse: Result<Void, Error>
    public var recieveLoginCallBackURLAndFetchAccessTokenStubbedResponse: Result<String, Error>
    public var logoutStubbedResponse: Result<Void, Error>
    
    // GitHubAPIClientFetchReposProtocol
    public var searchReposStubbedResponse: Result<SearchResponse<Repo>, GitHubAPIClientError>
    public var fetchAuthenticatedUserReposStubbedResponse: Result<ListResponse<Repo>, GitHubAPIClientError>
    public var fetchUserReposStubbedResponse: Result<ListResponse<Repo>, GitHubAPIClientError>
    public var fetchRepoStubbedResponse: Result<Repo, GitHubAPIClientError>
    
    // GitHubAPIClientFetchUserProtocol
    public var fetchLoginUserStubbedResponse: Result<LoginUser, GitHubAPIClientError>
    public var fetchUserStubbedResponse: Result<User, GitHubAPIClientError>
    
    // GitHubAPIClientStarredProtocol
    public var fetchStarredReposStubbedResponse: Result<StarredReposResponse, GitHubAPIClientError>
    public var checkIsRepoStarredStubbedResponse: Result<Bool, GitHubAPIClientError>
    public var starRepoStubbedResponse: Result<Void, GitHubAPIClientError>
    public var unstarRepoStubbedResponse: Result<Void, GitHubAPIClientError>
    
    // MARK: - LifeCycle
    
    public init(
        // GitHubAPIClientAuthorizationProtocol
        openLoginPageInBrowserStubbedResponse: Result<Void, Error> = .success(()),
        recieveLoginCallBackURLAndFetchAccessTokenStubbedResponse: Result<String, Error> = .success("stubbed_access_token"),
        logoutStubbedResponse: Result<Void, Error> = .success(()),
        
        // GitHubAPIClientFetchReposProtocol
        searchReposStubbedResponse: Result<SearchResponse<Repo>, GitHubAPIClientError> = .success(.init(totalCount: 0, items: [])),
        fetchAuthenticatedUserReposStubbedResponse: Result<ListResponse<Repo>, GitHubAPIClientError> = .success(.init(items: [])),
        fetchUserReposStubbedResponse: Result<ListResponse<Repo>, GitHubAPIClientError> = .success(.init(items: [])),
        fetchRepoStubbedResponse: Result<Repo, GitHubAPIClientError> = .success(Repo.Mock.random()),
        
        // GitHubAPIClientFetchUserProtocol
        fetchLoginUserStubbedResponse: Result<LoginUser, GitHubAPIClientError> = .success(LoginUser.Mock.ikeh),
        fetchUserStubbedResponse: Result<User, GitHubAPIClientError> = .success(User.Mock.random()),
        
        // GitHubAPIClientStarredProtocol
        fetchStarredReposStubbedResponse: Result<StarredReposResponse, GitHubAPIClientError> = .success(.init(starredRepos: [])),
        checkIsRepoStarredStubbedResponse: Result<Bool, GitHubAPIClientError> = .success(true),
        starRepoStubbedResponse: Result<Void, GitHubAPIClientError> = .success(()),
        unstarRepoStubbedResponse: Result<Void, GitHubAPIClientError> = .success(())
    ) {
        self.openLoginPageInBrowserStubbedResponse = openLoginPageInBrowserStubbedResponse
        self.recieveLoginCallBackURLAndFetchAccessTokenStubbedResponse = recieveLoginCallBackURLAndFetchAccessTokenStubbedResponse
        self.logoutStubbedResponse = logoutStubbedResponse        
        self.searchReposStubbedResponse = searchReposStubbedResponse
        self.fetchAuthenticatedUserReposStubbedResponse = fetchAuthenticatedUserReposStubbedResponse
        self.fetchUserReposStubbedResponse = fetchUserReposStubbedResponse
        self.fetchRepoStubbedResponse = fetchRepoStubbedResponse
        self.fetchLoginUserStubbedResponse = fetchLoginUserStubbedResponse
        self.fetchUserStubbedResponse = fetchUserStubbedResponse
        self.fetchStarredReposStubbedResponse = fetchStarredReposStubbedResponse
        self.checkIsRepoStarredStubbedResponse = checkIsRepoStarredStubbedResponse
        self.starRepoStubbedResponse = starRepoStubbedResponse
        self.unstarRepoStubbedResponse = unstarRepoStubbedResponse
    }
    
}

// MARK: - GitHubAPIClientAuthorizationProtocol

extension GitHubAPIClientStub: GitHubAPIClientAuthorizationProtocol {
    
    public func openLoginPageInBrowser() async throws {
        try openLoginPageInBrowserStubbedResponse.get()
    }
    
    public func recieveLoginCallBackURLAndFetchAccessToken(_ url: URL) async throws -> String {
        return try recieveLoginCallBackURLAndFetchAccessTokenStubbedResponse.get()
    }
    
    public func logout(accessToken: String) async throws {
        try logoutStubbedResponse.get()
    }
}

// MARK: - GitHubAPIClientFetchReposProtocol

extension GitHubAPIClientStub: GitHubAPIClientFetchReposProtocol {
    public func searchRepos(query: String, accessToken: String?, sort: String?, order: String?, perPage: Int?, page: Int?) async throws -> SearchResponse<Repo> {
        try searchReposStubbedResponse.get()
    }
    
    public func fetchAuthenticatedUserRepos(accessToken: String, visibility: String?, affiliation: String?, type: String?, sort: String?, direction: String?, perPage: Int?, page: Int?, since: String?, before: String?) async throws -> ListResponse<Repo> {
        return try fetchAuthenticatedUserReposStubbedResponse.get()
    }
    
    public func fetchUserRepos(userName: String, accessToken: String?, type: String?, sort: String?, direction: String?, perPage: Int?, page: Int?) async throws -> ListResponse<Repo> {
        return try fetchUserReposStubbedResponse.get()
    }
    
    public func fetchRepo(owner: String, repo: String, accessToken: String?) async throws -> Repo {
        return try fetchRepoStubbedResponse.get()
    }
}

// MARK: - GitHubAPIClientFetchUserProtocol

extension GitHubAPIClientStub: GitHubAPIClientFetchUserProtocol {
    public func fetchLoginUser(accessToken: String) async throws -> LoginUser {
        return try fetchLoginUserStubbedResponse.get()
    }
    
    public func fetchUser(accessToken: String, userName: String) async throws -> User {
        return try fetchUserStubbedResponse.get()
    }
}

// MARK: - GitHubAPIClientStarredProtocol

extension GitHubAPIClientStub: GitHubAPIClientStarredProtocol {
    public func fetchStarredRepos(userName: String, accessToken: String?, sort: String?, direction: String?, perPage: Int?, page: Int?) async throws -> StarredReposResponse {
        return try fetchStarredReposStubbedResponse.get()
    }
    
    public func checkIsRepoStarred(accessToken: String, owner: String, repo: String) async throws -> Bool {
        return try checkIsRepoStarredStubbedResponse.get()
    }
    
    public func starRepo(accessToken: String, owner: String, repo: String) async throws {
        try starRepoStubbedResponse.get()
    }
    
    public func unstarRepo(accessToken: String, owner: String, repo: String) async throws {
        try unstarRepoStubbedResponse.get()
    }
}
