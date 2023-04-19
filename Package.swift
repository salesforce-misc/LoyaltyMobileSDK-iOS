// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoyaltyMobileSDK-iOS",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LoyaltyMobileSDK",
            targets: ["LoyaltyMobileSDK"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LoyaltyMobileSDK",
            dependencies: []),
        .testTarget(
            name: "LoyaltyMobileSDKTests",
            dependencies: ["LoyaltyMobileSDK"],
            resources: [
                .copy("JSONFiles/Profile.json"),
                .copy("JSONFiles/Benefits.json"),
                .copy("JSONFiles/Enrollment.json"),
                .copy("JSONFiles/EnrollmentPromotion.json"),
                .copy("JSONFiles/UnenrollmentPromotion.json"),
                .copy("JSONFiles/Promotions.json"),
                .copy("JSONFiles/Vouchers.json"),
                .copy("JSONFiles/Transactions.json")
            ]),
    ]
)
