// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ClearDisk",
    defaultLocalization: "en",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "ClearDisk",
            path: "Sources/ClearDisk",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
