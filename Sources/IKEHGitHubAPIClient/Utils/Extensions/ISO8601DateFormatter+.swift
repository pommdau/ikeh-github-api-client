import Foundation

extension ISO8601DateFormatter {
    /// e.g. "2024-12-21T12:20:29Z"
    nonisolated(unsafe) static let shared: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
}
