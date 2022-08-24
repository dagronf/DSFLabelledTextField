// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "DSFLabelledTextField",
	platforms: [
		.macOS(.v10_11)
	],
	products: [
		.library(
			name: "DSFLabelledTextField",
			type: .static,
			targets: ["DSFLabelledTextField"]
		),
		.library(
			name: "DSFLabelledTextField-Dynamic",
			type: .dynamic,
			targets: ["DSFLabelledTextField"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/dagronf/DSFAppearanceManager", from: "3.0.0")
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages this package depends on.
		.target(
			name: "DSFLabelledTextField",
			dependencies: ["DSFAppearanceManager"]),
		.testTarget(
			name: "DSFLabelledTextFieldTests",
			dependencies: ["DSFLabelledTextField"]),
	]
)
