// swift-tools-version: 5.10
import PackageDescription
// Note: swift-tools-version above pins the package manifest format. The
// generated Xcode app target compiles in Swift 5 mode (SWIFT_VERSION = 5.0)
// for maximum compatibility with Xcode 16; the package itself can opt into
// newer language features without affecting the app target.

/// KuwentaCore is the shared Swift package consumed by the iOS app and,
/// from Phase 2 onward, by the Message Filter Extension and Widget targets.
///
/// Today it ships small, framework-free utilities (SMS parser scaffolding,
/// brand tokens). The Core Data model still lives in the iOS app target
/// during Phase 1; when the Message Filter Extension is added in Phase 2,
/// move `Kuwenta.xcdatamodeld` into `Sources/KuwentaCore/Resources` and
/// switch both targets to load it via `KuwentaCore.persistentModel()`.
let package = Package(
    name: "KuwentaCore",
    platforms: [
        .iOS(.v18),
        .watchOS(.v11)
    ],
    products: [
        .library(name: "KuwentaCore", targets: ["KuwentaCore"])
    ],
    targets: [
        .target(
            name: "KuwentaCore",
            path: "Sources/KuwentaCore"
        ),
        .testTarget(
            name: "KuwentaCoreTests",
            dependencies: ["KuwentaCore"],
            path: "Tests/KuwentaCoreTests"
        )
    ]
)
