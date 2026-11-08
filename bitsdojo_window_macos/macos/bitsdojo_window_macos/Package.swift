// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "bitsdojo_window_macos",
    platforms: [
        .macOS("10.11"),
    ],
    products: [
        .library(
            name: "bitsdojo-window-macos",
            targets: ["bitsdojo_window_macos", "bitsdojo_window_macos_objc"]
        ),
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
    ],
    targets: [
        .target(
            name: "bitsdojo_window_macos_objc",
            path: "Sources/bitsdojo_window_macos_objc",
            cSettings: [
                .headerSearchPath("include/bitsdojo_window_macos"),
            ]
        ),
        .target(
            name: "bitsdojo_window_macos",
            dependencies: [
                "bitsdojo_window_macos_objc",
                .product(name: "FlutterFramework", package: "FlutterFramework"),
            ],
            path: "Sources/bitsdojo_window_macos"
        ),
    ]
)
