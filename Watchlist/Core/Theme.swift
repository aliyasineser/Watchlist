//
//  Theme.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 14.08.2021.
//

import Foundation
import SwiftUI


enum Theme: Int {
    case light
    case dark
    
    var colorScheme: ColorScheme {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    
}


class AppSettings: ObservableObject {

    static let shared = AppSettings()
    
    @AppStorage("current_theme") var currentTheme: Theme = .light
}
