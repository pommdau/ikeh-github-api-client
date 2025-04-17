import Foundation
import SwiftID

// 各DTOに対応したID型を定義する汎用型
public struct SwiftID<T>: StringIDProtocol {
    public let rawValue: String
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

/// GitHubAPIで扱うDTOモデル用のプロトコル
public protocol GitHubItem: Identifiable, Codable, Sendable, Hashable, Equatable {
    associatedtype Model
    var id: SwiftID<Model> { get } // 各DTOにユニークな型のIDを定義させる
}
