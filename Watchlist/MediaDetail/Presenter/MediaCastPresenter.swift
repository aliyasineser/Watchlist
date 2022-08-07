//
//  MediaCastPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation

@MainActor
class MediaCastPresenter: ObservableObject {
    private let interactor: MediaCastInteractor
    @Published var artists: [CastMemberEntity]
    
    var id: Int
    var mediaType: MediaType
    
    init(_ interactor: MediaCastInteractor, id: Int, mediaType: MediaType) {
        self.id = id
        self.mediaType = mediaType
        self.interactor = interactor
        self.artists = [CastMemberEntity]()
    }
    
    public func loadArtists() -> Void {
        Task {
            self.artists = await interactor.fetchCast(self.id, mediaType: self.mediaType)
        }
    }
    
}
