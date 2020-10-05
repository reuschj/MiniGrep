// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "minigrep",
    products: [
        .executable(name: "minigrep", targets: ["minigrep"]),
        .library(name: "MiniGrepLib", targets: ["MiniGrepLib"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.0"),
        .package(url: "https://github.com/reuschj/QueryRangeIterator", from: "0.1.0"),
        .package(url: "https://github.com/reuschj/TerminalColor", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package,
        // and on products in packages which this package depends on.
        .target(
            name: "minigrep",
            dependencies: [
                "MiniGrepLib",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "TerminalColor", package: "TerminalColor")
            ]),
        .target(
            name: "MiniGrepLib",
            dependencies: [
                .product(name: "QueryRangeIterator", package: "QueryRangeIterator"),
                .product(name: "TerminalColor", package: "TerminalColor")
            ]),
        .testTarget(
            name: "MiniGrepTests",
            dependencies: ["MiniGrepLib"],
            resources: [.process("Assets/poem.txt")]),
    ]
)
