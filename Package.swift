// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWCropViewController",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "WWCropViewController", targets: ["WWCropViewController"]),
    ],
    targets: [
        .target(name: "WWCropViewController",
                resources: [
                    .copy("Privacy"),
                    .process("Storyboard"),
                    .process("Material")
                ]
               ),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
