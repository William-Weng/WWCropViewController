// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWCropViewController",
    platforms: [
        .iOS(.v13)
    ],
    products: [.library(name: "WWCropViewController", targets: ["WWCropViewController"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "WWCropViewController", dependencies: [], resources: [.process("Material"), .process("Storyboard"), .copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
