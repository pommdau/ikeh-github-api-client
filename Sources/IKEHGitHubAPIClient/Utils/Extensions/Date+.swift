//
//  Date+.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation

extension Date {
    /// 過去n年間のランダムな日時の作成
    static func random(inPastYears years: Int) -> Date {
        let now = Date()
        let secondsInYear: TimeInterval = 365 * 24 * 60 * 60
        let randomOffset = TimeInterval.random(in: 0...(Double(years) * secondsInYear))
        
        return now.addingTimeInterval(-randomOffset)
    }
}
