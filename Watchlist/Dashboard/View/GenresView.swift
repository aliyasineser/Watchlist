//
//  GenresView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//

import SwiftUI

struct GenresView: View {
    
    var interactor: GenresInteractor
    @ObservedObject var presenter: GenresPresenter
    
    init() {
        self.interactor = GenresInteractor()
        self.presenter = GenresPresenter(self.interactor)
        self.presenter.fetchGenres()
    }
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            VStack(spacing: 10) {
                ForEach(self.presenter.genres, id: \.id) { item in
                    GenreItem(genre: item.name)
                }
            }
        }
        .background(Color.veryLightPink)
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
       
    }
}

struct GenresView_Previews: PreviewProvider {
    static var previews: some View {
        GenresView()
    }
}
