// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

var targets: [Target] = []
var products: [Product] = []


// put all xcframework
//
let dependencies: [String] = [
// MARK: Analytics
    "PromisesObjC.xcframework",
    "GoogleDataTransport.xcframework",
    "GoogleUtilities.xcframework",
    "nanopb.xcframework",
    "GoogleAppMeasurement.xcframework",
    "GoogleAppMeasurementIdentitySupport.xcframework",
    "FirebaseCoreDiagnostics.xcframework",
    "FirebaseInstallations.xcframework",
    "FirebaseAnalytics.xcframework",
    "FirebaseCore.xcframework",
//Auth
    "FirebaseAuth.xcframework",
    "GTMSessionFetcher.xcframework",
//Crashlytics
    "FirebaseCrashlytics.xcframework",
//Firestore
    "BoringSSL-GRPC.xcframework",
    "FirebaseFirestore.xcframework",
    "abseil.xcframework",
    "gRPC-C++.xcframework",
    "gRPC-Core.xcframework",
    "leveldb-library.xcframework",
//FirebaseStorage
    "FirebaseStorage.xcframework",
    "GTMSessionFetcher.xcframework",
//Google Signin
    "AppAuth.xcframework",
    "GTMAppAuth.xcframework",
    "GTMSessionFetcher.xcframework",
    "GoogleSignIn.xcframework",
]
// remove duplicated frameworks
let duplicatedRemoved = Array(Set(dependencies))

//---------------------
func removeFileExtension(targetNames: [String]) -> [String] {
    return targetNames.map { name in
        return name.replacingOccurrences(of: ".xcframework", with: "")
    }
}
func toDependencies(targetNames: [String]) -> [Target.Dependency] {
    return targetNames.map { name in
        let targetName = name.replacingOccurrences(of: ".xcframework", with: "")
        return Target.Dependency.byNameItem(name: targetName, condition: nil)
    }
}
func toTargets(targetNames: [String]) -> [Target] {
    return targetNames.map { name in
        if name.hasSuffix(".xcframework") {
            let targetName = name.replacingOccurrences(of: ".xcframework", with: "")
            return Target.binaryTarget(
                name: targetName,
                path: name
            )
        }
        return Target.target(name: name)
    }
}


// MARK: Main
let package = Package(
    name: "FirebaseLibraries",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "FirebaseTarget",
            targets: removeFileExtension(targetNames: duplicatedRemoved)
             + ["FirebaseFirestoreSwift"]
        )
    ],
    targets: toTargets(targetNames: duplicatedRemoved)
    + [
        .target(
            name: "FirebaseFirestoreSwift",
            
            dependencies: [
                "FirebaseFirestore"
            ]
        )
    ],
    cxxLanguageStandard: .cxx14
)
