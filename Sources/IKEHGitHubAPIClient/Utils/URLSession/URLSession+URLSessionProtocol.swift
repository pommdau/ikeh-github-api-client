import Foundation
import HTTPTypesFoundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// - NOTE: デフォルトで実装済みのため準拠のみでOK
extension URLSession: URLSessionProtocol {}
