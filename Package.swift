// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
/*
 refs: refs: [Server-Side SwiftでSwiftLintのpluginとSwift buildを両立する方法](https://zenn.dev/nextbeat/articles/70b9a6b85a1ca3)
 
 https://forums.swift.org/t/swiftpm-and-swappable-libraries/43593
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
    dependencies: dependencies,
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
            swiftSettings: swiftSettings,
            plugins: swiftLintPlugins,
        ),
    ]
)

// MARK: - Helpers

var dependencies: [Package.Dependency] {
    var dependencies: [Package.Dependency] = [
        .package(url: "https://github.com/apple/swift-http-types", from: "1.3.1"),
    ]
    if Environment.enableSwiftLintPlugins {
        dependencies.append(
            .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.1.0"),
        )
    }
    return dependencies
}

var swiftSettings: [SwiftSetting] {
    return [
        .enableExperimentalFeature("StrictConcurrency"),
    ]
}

var swiftLintPlugins: [Target.PluginUsage] {
    if Environment.enableSwiftLintPlugins {
        return [
            .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
        ]
    }
    return []
}

/// GitHub上では.github/workflows/swiftlint.yamlのenvで指定する
/// 本PackageではXcodeの起動時に引数を渡すことで指定する
enum Environment {
    static func get(_ key: String) -> String? {
        
        
        
        
        
        
        return ProcessInfo.processInfo.environment[key]
    }
    static var enableSwiftLintPlugins: Bool {
//        return true
        Self.get("ENABLE_SWIFTLINT_PLUGINS") == "true"
    }
}


