// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
        .package(url: "https://github.com/koher/swift-id", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "IKEHGitHubAPIClient",
            dependencies: [
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .product(name: "HTTPTypesFoundation", package: "swift-http-types"),
                .product(name: "SwiftID", package: "swift-id"),
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ],
        ),
        .testTarget(
            name: "IKEHGitHubAPIClientTests",
            dependencies: ["IKEHGitHubAPIClient"]
        ),
    ]
)
