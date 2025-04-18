// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "flutter_custom_tabs_ios",
  platforms: [
    .iOS("12.0")
  ],
  products: [
    .library(name: "flutter-custom-tabs-ios", targets: ["flutter_custom_tabs_ios"])
  ],
  dependencies: [],
  targets: [
    .target(
      name: "flutter_custom_tabs_ios",
      dependencies: [],
      resources: [
        .process("Resources")
      ]
    )
  ]
)