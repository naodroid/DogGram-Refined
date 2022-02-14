// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DogGramLibs",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DataLayer",
            targets: ["DataLayer"]
        ),
        .library(
            name: "DomainLayer",
            targets: ["DomainLayer"]
        ),
        .library(
            name: "UILayer",
            targets: ["UILayer"]
        ),
    ],
    dependencies: [
        .package(name: "FirebaseLibraries", path: "../Firebase/")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DataLayer",
            dependencies: [
                .product(name: "FirebaseTarget", package: "FirebaseLibraries")
            ]
        ),
        .target(
            name: "DomainLayer",
            dependencies: [
                "DataLayer",
            ]
        ),
        .target(
            name: "UILayer",
            dependencies: [
                "DataLayer",
                "DomainLayer",
            ]
        ),
    ]
)
