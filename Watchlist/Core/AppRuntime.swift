import Foundation

enum AppRuntime {
    static var usesTestDependencies: Bool {
        #if DEBUG
        ProcessInfo.processInfo.arguments.contains("--ui-testing") ||
            ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        #else
        false
        #endif
    }
}
