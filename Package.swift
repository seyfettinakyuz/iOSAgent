// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InstanaAgent",
    platforms: [.iOS(.v11), .macOS(.v10_15)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "InstanaAgent",
            targets: ["InstanaAgent"]),
    ],
    dependencies: [
        .package(url: "https://github.com/1024jp/GzipSwift.git", from: "5.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "ImageTracker", dependencies: [], publicHeadersPath: ""),
        .target(
            name: "InstanaAgent",
            dependencies: ["Gzip", "ImageTracker"]),
        .testTarget(
            name: "InstanaAgentTests",
            dependencies: ["InstanaAgent", "ImageTracker"]),
    ]
)
