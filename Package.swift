// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkClientPackage",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "NetworkClientPackage",
            targets: ["NetworkClientPackage"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "Reachability", url: "https://github.com/ashleymills/Reachability.swift", .upToNextMajor(from: "5.1.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "NetworkClientPackage",
            dependencies: [.product(name: "Reachability", package: "Reachability")]),
        .testTarget(
            name: "NetworkClientPackageTests",
            dependencies: ["NetworkClientPackage"]),
    ]
)
