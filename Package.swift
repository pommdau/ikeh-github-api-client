// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
/*
 refs: refs: [Server-Side SwiftでSwiftLintのpluginとSwift buildを両立する方法](https://zenn.dev/nextbeat/articles/70b9a6b85a1ca3)
 */


import Foundation
import PackageDescription

let package = Package(
    name: "IKEHGitHubAPIClient",
    platforms: [
        .iOS(.v17),
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "IKEHGitHubAPIClient",
            targets: ["IKEHGitHubAPIClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-http-types", from: "1.3.1"),
    ],
    targets: [
        .target(
            name: "IKEHGitHubAPIClient",
            dependencies: [
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .product(name: "HTTPTypesFoundation", package: "swift-http-types"),
            ],
            swiftSettings: swiftSettings,
            plugins: swiftLintPlugins,
        ),
        .testTarget(
            name: "IKEHGitHubAPIClientTests",
            dependencies: ["IKEHGitHubAPIClient"],
            plugins: swiftLintPlugins,
        ),
    ]
)

// MARK: - Helpers


var swiftSettings: [SwiftSetting] {
    return [
        .enableExperimentalFeature("StrictConcurrency"),
    ]
}

var swiftLintPlugins: [Target.PluginUsage] {
    guard Environment.enableSwiftLint else {
        return []
    }
    return [
        .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
    ]
}

/// .github/workflows/swiftlint.yamlのenvで指定する
enum Environment {
    static func get(_ key: String) -> String? {
        ProcessInfo.processInfo.environment[key]
    }
    static var enableSwiftLint: Bool {
        Self.get("SWIFTLINT") == "true"
    }
}
