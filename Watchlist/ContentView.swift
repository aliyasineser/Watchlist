//
//  ContentView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 23.03.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var dependencies: AppDependencies = AppDependenciesImpl()

    var body: some View {
        DashboardView(dependencies: dependencies)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
