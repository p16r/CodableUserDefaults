// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "CodableUserDefaults",
    platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "CodableUserDefaults", targets: ["CodableUserDefaults"])
    ],
    targets: [
        .target(name: "CodableUserDefaults", dependencies: []),
        .testTarget(
            name: "CodableUserDefaultsTests",
            dependencies: ["CodableUserDefaults"]
        ),
    ]
)
