//
//  ContentView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 23.03.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        DashboardView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
