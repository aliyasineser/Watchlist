//
//  WatchlistApp.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 23.03.2021.
//

import SwiftUI
import TMDBSwift

@main
struct WatchlistApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        TMDBConfig.apikey = "43103292afecd22342eba92e93b8c479"
    }
    
    var body: some Scene {
        WindowGroup {
            
            OnboardingView()
            
        }
    }
}
