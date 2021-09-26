//
//  CastView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 8.09.2021.
//

import SwiftUI

struct CastView: View {
    private var interactor: CastInteractor
    @ObservedObject var presenter: CastPresenter
    
    let columns = [
            GridItem(.adaptive(minimum: 100))
        ]
    
    var id: Int
    var mediaType: MediaType
    
    init(_ id: Int, mediaType: MediaType) {
        self.id = id
        self.mediaType = mediaType
        self.interactor = CastInteractor()
        self.presenter = CastPresenter(self.interactor, id: self.id, mediaType: mediaType)
        
        presenter.loadArtists()
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                ForEach(self.presenter.artists) { (artist) -> CastItemView in
                    CastItemView(imageUrl: artist.imageUrl, name: artist.name, character: artist.character)
                }
                Spacer()
                    .onAppear(perform: {
                        presenter.loadArtists()
                })
            }
        }
//        .navigationBarBackButtonHidden(true)
        .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
        
    }
}

struct CastView_Previews: PreviewProvider {
    static var previews: some View {
        CastView(134, mediaType: .movie)
    }
}
