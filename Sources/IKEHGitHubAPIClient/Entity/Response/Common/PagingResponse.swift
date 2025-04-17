//
//  ResponseWithRelationLink.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/27.
//

import Foundation

/// ページング情報のあるレスポンス用のプロトコル
protocol PagingResponse {
    var relationLink: RelationLink? { get set } // ページング情報
}
