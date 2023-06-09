// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
  name: "DynastyAnalystApp",
  platforms: [
    .iOS(.v16),
    .macOS(.v10_15)
  ],
  products: [
    .library(name: "Helpers", targets: ["Helpers"]),
    .library(name: "Home", targets: ["Home"]),
    .library(name: "Models", targets: ["Models"]),
    .library(name: "NetworkClient", targets: ["NetworkClient"]),
    .library(name: "RealmConfiguration", targets: ["RealmConfiguration"]),
    .library(name: "SwiftUIExtensions", targets: ["SwiftUIExtensions"]),
    .library(name: "TCAExtensions", targets: ["TCAExtensions"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-async-algorithms", from: "0.0.4"),
    .package(url: "https://github.com/realm/realm-swift.git", .upToNextMinor(from: "10.32.3")),
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.7.2"),
    .package(url: "https://github.com/EcolabCompany/FoundationExtensions", from: "2.3.1"),
    .package(url: "https://github.com/EcolabCompany/RealmExtensions", from: "3.5.2"),
    .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "0.1.1"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.50.1"),
    .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "0.3.0"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "0.1.4"),
    .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "0.5.0"),
    .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "0.3.2")
  ],
  targets: [
    .target(
      name: "Helpers",
      dependencies: [
        "FoundationExtensions",
      ]
    ),
    .target(
      name: "Home",
      dependencies: [
        "Models",
        "NetworkClient",
        "RealmConfiguration",
        "TCAExtensions",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "Models",
      dependencies: [
        .product(name: "RealmSwift", package: "realm-swift")
      ]
    ),
    .target(
      name: "NetworkClient",
      dependencies: [
        "Helpers",
        "Models",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "RealmConfiguration",
      dependencies: [
        "Helpers",
        .product(name: "RealmSwift", package: "realm-swift")
      ]
    ),
    .target(
      name: "SwiftUIExtensions",
      dependencies: [
        "FoundationExtensions",
      ]
    ),
    .target(
      name: "TCAExtensions",
      dependencies: [
        "FoundationExtensions",
        "RealmExtensions",
        "SwiftUIExtensions",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
  ]
)
