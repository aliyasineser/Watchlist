//
//  MediaNetworkRequest.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 18.09.2022.
//

import Foundation

protocol MediaNetworkRequest: NetworkRequest {
    var mediaType: MediaType { get }
}
