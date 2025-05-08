import Foundation

/// GitHubAPIで扱うDTOクラス用のプロトコル
public protocol GitHubItem: Identifiable, Codable, Sendable, Hashable, Equatable {}
