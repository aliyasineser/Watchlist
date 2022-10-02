//
//  MovieReviewView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.10.2022.
//

import SwiftUI

struct MovieReviewView: View {

    @ObservedObject var presenter: MovieReviewDefaultPresenter

    var body: some View {
        ScrollView(.vertical) {
            ForEach(presenter.reviews) { review in
                ReviewItem(review: review)
            }
        }
        .onAppear {
            presenter.fetchReviews()
        }
    }
}

struct MovieReviewView_Previews: PreviewProvider {
    static var previews: some View {
        MovieReviewView(
            presenter: MovieReviewDefaultPresenter(
                interactor: MovieReviewInteractorStub(),
                id: 1
            )
        )
    }
}
