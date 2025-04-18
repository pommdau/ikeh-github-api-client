import Foundation

extension GitHubAPIClient {
    
    public func searchRepos(
        accessToken: String,
        searchText: String,
        sort: String? = nil,
        order: String? = nil,
        page: Int? = nil,
        perPage: Int? = nil
    ) async throws -> SearchResponse<Repo> {
        let request = GitHubAPIRequest.SearchReposRequest(
            accessToken: accessToken,
            query: searchText,
            sort: sort,
            order: order,
            page: page,
            perPage: perPage
        )
        let response = try await performRequest(with: request)
        return response
    }
    
    public func fetchUserRepos(userName: String, accessToken: String? = nil, perPage: Int? = nil, page: Int? = nil) async throws -> ListResponse<Repo> {
        let request = GitHubAPIRequest.FetchUserRepos(accessToken: accessToken, userName: userName, perPage: perPage, page: page)
        let response = try await performRequest(with: request)
        return response
    }
    
    public func fetchRepo(owner: String, repo: String, accessToken: String? = nil) async throws -> Repo {
        let request = GitHubAPIRequest.FetchRepo(accessToken: accessToken, owner: owner, repo: repo)
        let response = try await performRequest(with: request)
        return response
    }
}
