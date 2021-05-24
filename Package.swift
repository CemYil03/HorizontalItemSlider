// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ItemSliderModule",
    platforms: [
        .iOS(SupportedPlatform.IOSVersion.v14)
    ],
    products: [
        .library(
            name: "ItemSlider",
            targets: ["ItemSlider"]
        )
    ],
    targets: [
        .target(
            name: "ItemSlider"
        )
    ]
)
