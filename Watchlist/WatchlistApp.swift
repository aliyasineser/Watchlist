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

    private var isUITesting: Bool {
        #if DEBUG
        ProcessInfo.processInfo.arguments.contains("--ui-testing")
        #else
        false
        #endif
    }

    var body: some Scene {
        WindowGroup {
            if isUITesting || PersistenceController.shared.loadError == nil {
                ContentView(dependencies: dependencies)
                    .modifier(UITestAppearance())
            } else {
                ContentUnavailableView {
                    Label("Your library couldn’t be opened", systemImage: "externaldrive.badge.exclamationmark")
                } description: {
                    Text("Your saved data has not been deleted. Try opening it again.")
                } actions: {
                    Button("Try again") { PersistenceController.shared.loadStores() }
                        .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

private struct UITestAppearance: ViewModifier {
    func body(content: Content) -> some View {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--ui-testing-accessibility") {
            content.environment(\.dynamicTypeSize, .accessibility3).preferredColorScheme(.dark)
        } else {
            content
        }
        #else
        content
        #endif
    }
}
