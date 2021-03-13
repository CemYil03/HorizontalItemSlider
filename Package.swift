// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HorizontalItemSlider",
    platforms: [
        .iOS(SupportedPlatform.IOSVersion.v14)
    ],
    products: [
        .library(
            name: "HorizontalItemSlider",
            targets: ["HorizontalItemSlider"]
        )
    ],
    targets: [
        .target(
            name: "HorizontalItemSlider"
        )
    ]
)
