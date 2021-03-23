//
//  WatchlistApp.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 23.03.2021.
//

import SwiftUI

@main
struct WatchlistApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            OnboardingView()
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
