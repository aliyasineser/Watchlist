//
//  MovieReviewView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.10.2022.
//

import SwiftUI

struct MovieReviewView: View {

    @State var presenter: MediaReviewDefaultPresenter

    var body: some View {
        ScrollView(.vertical) {
            ForEach(presenter.reviews) { review in
                ReviewItem(review: review)
            }
        }
        .task {
            await presenter.fetchReviews()
        }
        .errorAlert(error: $presenter.fetchError)
    }
}

struct MovieReviewView_Previews: PreviewProvider {
    static var previews: some View {
        MovieReviewView(
            presenter: MediaReviewDefaultPresenter(
                interactor: MediaReviewInteractorStub(),
                id: 1
            )
        )
    }
}
