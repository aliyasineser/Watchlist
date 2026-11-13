//
//  WatchlistApp.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 23.03.2021.
//

import SwiftUI

@main
struct WatchlistApp: App {
    private var dependencies: AppDependencies {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--ui-testing") {
            return UITestAppDependencies()
        }
        #endif
        return AppDependenciesImpl()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(dependencies: dependencies)
        }
    }
}
