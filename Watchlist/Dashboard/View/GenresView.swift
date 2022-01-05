//
//  GenresView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//

import SwiftUI

struct GenresView: View {
    
    @ObservedObject var presenter: GenresPresenter
    
    init(_ presenter: GenresPresenter) {
        self.presenter = presenter
        self.presenter.fetchGenres()
    }
    
    var body: some View {
        
        NavigationView {
            ScrollView(showsIndicators: true) {
                VStack(spacing: 10) {
                    ForEach(self.presenter.genres, id: \.id) { item in
                        GenreItem(genre: item.name)
                    }
                }
            }
            .navigationBarTitle(ConstantTexts.genresScreenNavBarTitle)
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
       
    }
}

struct GenresView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = GenresInteractor()
        let presenter = GenresPresenter(interactor)
        GenresView(presenter)
    }
}
