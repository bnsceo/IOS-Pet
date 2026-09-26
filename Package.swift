// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "IOSPetCore",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "PetCore", targets: ["PetCore"])
    ],
    targets: [
        .target(name: "PetCore", path: "Shared"),
        .testTarget(name: "PetCoreTests", dependencies: ["PetCore"], path: "Tests/PetCoreTests")
    ]
)
